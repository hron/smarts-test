require 'test_helper'

class TasksControllerTest < ActionController::TestCase
  # test "should get index" do
  #   get :index
  #   assert_response :success
  #   assert_not_nil assigns(:tasks)
  # end

  test "should create task" do
    @request.accept = 'text/xml'
    BackgrounDRb::RailsWorkerProxy.any_instance.expects(:async_calculate).returns("ok")
    post(:create,
         :task => {
           :type => :quadratic_equaction,
           "parameters" => { "a" => 1, "b" => 1, "c" => 1}})
    assert_response :created
  end

  test "should do not create task, if worker cant schedule the job" do
    @request.accept = 'text/xml'
    BackgrounDRb::RailsWorkerProxy.any_instance.expects(:async_calculate).returns(nil)
    post(:create,
         :task => {
           :type => :quadratic_equaction,
           "parameters" => { "a" => 1, "b" => 1, "c" => 1}})
    assert_response :unprocessable_entity
  end

  test "should show task" do
    result = {
      :type => 'quadratic_equaction',
      :answer => "x = 5"
    }
    BackgrounDRb::RailsWorkerProxy.any_instance.expects(:ask_result).returns(result)
    get :show, :id => "quadratic_equaction-a0b3c-15"
    assert_response :success
  end

  test "should get failure when access invalid worker" do
    BackgrounDRb::RailsWorkerProxy.any_instance.expects(:ask_result).returns(nil)
    get :show, :id => "invalidworker-blah1-sdlfkj%sldkfj"
    assert_response :missing
  end

  # test "should destroy task" do
  #   assert_difference('Task.count', -1) do
  #     delete :destroy, :id => tasks(:one).to_param
  #   end

  #   assert_redirected_to tasks_path
  # end
end
