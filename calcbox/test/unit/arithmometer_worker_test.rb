require File.join(File.dirname(__FILE__) + "/../bdrb_test_helper")
require 'test_helper'
require "arithmometer_worker" 

class GameTest < ActiveSupport::TestCase
  def setup 
    @arithmometer = ArithmometerWorker.new
    @arithmometer.create
  end
  
  test "home and visiting teams cant be the same" do
    assert_equal 4, @arithmometer.sum( { :a => 2, :b => 2})
  end
end
