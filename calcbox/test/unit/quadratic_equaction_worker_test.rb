require File.join(File.dirname(__FILE__) + "/../bdrb_test_helper")
require 'test_helper'
require "quadratic_equaction_worker" 

class QuadraticEquactionWorkerTest < ActiveSupport::TestCase
  def setup 
    @qe_worker = QuadraticEquactionWorker.new
  end
  
  test "should reports errors if wrong number of arguments used" do
    @qe_worker.calculate(:parameters => { "a" => 1, "b" => 2})
    assert @qe_worker.cache["test"][:errors].include? I18n.t(:quadratic_equaction_errors_arguments_count)
  end

  test "should reports errors if some of arguments is not a numbers" do
    @qe_worker.calculate(:parameters => { "a" => 1, "b" => "blah", "c" => 3})
    assert @qe_worker.cache["test"][:errors].include? I18n.t(:quadratic_equaction_errors_arguments_integer)
  end

  test "should reports that the root of the equation is any number when a=b=c=0" do
    @qe_worker.calculate(:parameters => { "a" => 0, "b" => 0, "c" => 0 })
    assert_answer_equal I18n.t(:quadratic_equaction_answer_any_number)
  end

  test "should reports no roots if a=b=0" do
    @qe_worker.calculate(:parameters => { "a" => 0, "b" => 0, "c" => 125})
    assert_answer_equal I18n.t(:quadratic_equaction_answer_no_roots)
  end

  test "should resolve correctly linear equaction 3x=15 (a=0,b=3,c=-15) => x=5" do
    @qe_worker.calculate(:parameters => { "a" => "0", "b" => "3", "c" => "-15"})
    assert_answer_equal "x = 5"
  end

  test "should resolve when d = 0, 2x*x+4x+2=0 (a=2,b=4,c=2)" do
    @qe_worker.calculate(:parameters => { "a" => 2, "b" => 4, "c" => 2})
    assert_answer_equal "x1 = x2 = -1"
  end

  test "should resolve when d < 0" do 
    @qe_worker.calculate(:parameters => { "a" => 1, "b" => 4, "c" => 14})
    assert_answer_equal "x1 = -2 + 3.16228*i; x2 = -2 - 3.16228*i"
  end

  test "should resolve when d > 0" do
    @qe_worker.calculate(:parameters => { "a" => 1, "b" => 20, "c" => 3})
    assert_answer_equal "x1 = -0.151142; x2 = -19.8489"
  end

  test "should save description in cache" do
    desc = "should save description in cache"
    @qe_worker.calculate(:description => desc, :parameters => { "a" => 1, "b" => 20, "c" => 3})
    assert_equal desc, @qe_worker.cache["test"][:description]
  end

  test "should calculate time" do
    @qe_worker.calculate(:parameters => { "a" => 1, "b" => 20, "c" => 3})
    assert_not_equal 0, @qe_worker.cache["test"][:time]
  end

  private

  def assert_answer_equal value
    assert_equal value, @qe_worker.cache["test"][:answer]
  end
end
