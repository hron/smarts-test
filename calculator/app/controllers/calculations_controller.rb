class CalculationsController < ApplicationController
  def new
  end

  def create
    # @task = Task.new(params[:task])
    @task = Task.new
    @task.type        = params[:task][:type]
    @task.description = params[:task][:description]
    @task.parameters  = params[:task][:parameters]

    if @task.save
      redirect_to :action => :show, :id => @task
    else
      redirect_to :action => :new
    end
  end

  def show
    @task = Task.find(params[:id])
  end
  
  def parameters_update
    if !request.xhr? || !Task::TYPES.include?( params[:task][:type])
      render :inline => "", :layout => false
      return
    end
    render :partial => 'parameters', :locals => { :parameters => Task::TYPES[params[:task][:type]]}
  end
end
