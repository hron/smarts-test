require File.join(File.dirname(__FILE__) + "/../bdrb_test_helper")
require 'test_helper'
require "line_equaction_from_points_worker" 

class LineEquactionFromPointsWorkerTest < ActiveSupport::TestCase
  def setup 
    @le_worker = LineEquactionFromPointsWorker.new
  end
  
  test "should reports errors if wrong number of arguments used" do
    @le_worker.calculate(:parameters => { "x1" => 1, "y2" => 2})
    assert @le_worker.cache["test"][:errors].include? I18n.t(:quadratic_equaction_errors_arguments_count)
  end

  test "should reports errors if some of arguments is not a numbers" do
    @le_worker.calculate(:parameters => { "x1" => 1, "y1" => "blah", "x2" => 3, "y2" => "13"})
    assert @le_worker.cache["test"][:errors].include? I18n.t(:quadratic_equaction_errors_arguments_integer)
  end

  test "should provide solution for (0,0);(1,1): y=x or y-x=0" do
    @le_worker.calculate(:parameters => { "x1" => 0, "y1" => 0, "x2" => "1", "y2" => "1"})
    assert_answer_equal "-x+y=0"
  end

  test "should provide solution for (0,1);(1,1): y=1" do
    @le_worker.calculate(:parameters => { "x1" => 0, "y1" => 1, "x2" => "1", "y2" => "1"})
    assert_answer_equal "y-1=0"
  end

  test "should provide solution for (0,37);(1,-107): y=1" do
    @le_worker.calculate(:parameters => { "x1" => 0, "y1" => 37, "x2" => "1", "y2" => "-107"})
    assert_answer_equal "144x+y-37=0"
  end

  # test "should reports that the root of the equation is any number when a=b=c=0" do
  #   @le_worker.calculate(:parameters => { "a" => 0, "b" => 0, "c" => 0 })
  #   assert_answer_equal I18n.t(:quadratic_equaction_answer_any_number)
  # end


  # private

  def assert_answer_equal value
    assert_equal value, @le_worker.cache["test"][:answer]
  end
end
