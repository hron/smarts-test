require 'test_helper'

class TaskTest < ActiveSupport::TestCase
  test "to_param should build good correct id" do 
    @task = Task.new
    @task.type = "quadratic_equaction"
    @task.parameters = { "a" => 0, "b" => 3, "c" => "-15"}
    assert_equal "quadratic_equaction-a0b3c-15", @task.to_param
  end
end
