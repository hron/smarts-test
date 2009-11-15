require 'test_helper'

class TasksTest < ActionController::IntegrationTest
  test "should create task and show results" do
    xml = <<EOF
<task>
  <type>quadratic_equaction</type>
  <description>some useful description</description>
  <parameters>
    <a>0</a>
    <b>3</b>
    <c>-15</c>
  </parameters>
</task>
EOF
    post('/tasks.xml', xml, :content_type => 'application/xml')
    assert_response :success
    get '/tasks/quadratic_equaction-a0b3c-15.xml'
    assert_response :success
    assert_tag :tag => "answer", :content => "x = 5"
    assert_tag :tag => "description", :content => "some useful description"
    assert_no_tag :tag => "time", :content => "0"
  end
end
