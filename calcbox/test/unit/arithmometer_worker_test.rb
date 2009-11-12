require File.join(File.dirname(__FILE__) + "/../bdrb_test_helper")
require 'test_helper'
require "arithmometer_worker" 

class ArithmometerWorkerTest < ActiveSupport::TestCase
  def setup 
    @arithmometer = ArithmometerWorker.new
  end
  
  test "trivial worker to test helper" do
    @arithmometer.sum({:a => 2, :b => 2})
    assert_equal 4, @arithmometer.cache["test"][:answer]
  end

  test "should reports errors if wrong number of arguments used" do
    @arithmometer.resolve_quadratic_equaction({ :a => 1, :b => 2})
    assert @arithmometer.cache["test"][:errors].include? I18n.t(:resolve_quadratic_equaction_errors_arguments)
  end

  test "should reports that the root of the equation is any number when a=b=c=0" do
    @arithmometer.resolve_quadratic_equaction({ :a => 0, :b => 0, :c => 0 })
    assert_answer_equal I18n.t(:resolve_quadratic_equaction_answer_any_number)
  end

  test "should reports no roots if a=b=0" do
    @arithmometer.resolve_quadratic_equaction({ :a => 0, :b => 0, :c => 125})
    assert_answer_equal I18n.t(:resolve_quadratic_equaction_answer_no_roots)
  end

  test "should resolve correctly linear equaction 3x=15 (a=0,b=3,c=-15) => x=5" do
    @arithmometer.resolve_quadratic_equaction({ :a => 0, :b => 3, :c => -15})
    assert_answer_equal "x = 5"
  end

  test "should resolve when d = 0, 2x*x+4x+2=0 (a=2,b=4,c=2)" do
    @arithmometer.resolve_quadratic_equaction({ :a => 2, :b => 4, :c => 2})
    assert_answer_equal "x1 = x2 = -1"
  end

  test "should resolve when d < 0" do 
    @arithmometer.resolve_quadratic_equaction({ :a => 1, :b => 4, :c => 14})
    assert_answer_equal "x1 = -2 + 3.16228*i; x2 = -2 - 3.16228*i"
  end

  test "should resolve when d > 0" do
    @arithmometer.resolve_quadratic_equaction({ :a => 1, :b => 20, :c => 3})
    assert_answer_equal "x1 = -0.151142; x2 = -19.8489"
  end

  private

  def assert_answer_equal value
    assert_equal value, @arithmometer.cache["test"][:answer]
  end
end
