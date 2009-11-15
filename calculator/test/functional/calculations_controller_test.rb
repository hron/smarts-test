require 'test_helper'

class CalculationsControllerTest < ActionController::TestCase
  test "should render _parameters.rhtml properly" do
    xhr :get, :parameters_update, :task => { :type => "quadratic_equaction" }
    assert_tag :tag => "input", :attributes => { :name => 'task[parameters][c]'}
  end
end
