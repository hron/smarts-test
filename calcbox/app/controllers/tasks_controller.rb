class TasksController < ApplicationController
  # GET /tasks
  # GET /tasks.xml
  # def index
  #   @tasks = Task.all

  #   respond_to do |format|
  #     format.xml  { render :xml => @tasks }
  #   end
  # end

  # GET /tasks/quadratic_equaction-a1b1c1.xml
  def show
    type, jkey = params[:id].match /([^-]+)-(.+)/
    worker = MiddleMan.worker(type_to_worker($1))
    unless @result = worker.ask_result($2)
      redirect_to '/404.html', :status => 404
    end
  end

  # POST /tasks.xml
  def create
    worker = MiddleMan.worker(type_to_worker(params[:task][:type]))
    respond_to do |format|
      if worker.async_calculate(:args => params[:task], :job_key => job_key)
        format.xml  { 
          render :inline => "", :status => :created, :location => task_path(job_key) 
        }
      else
        format.xml  {
          render :inline => "", :status => :unprocessable_entity
        }
      end
    end
  end

  # # DELETE /tasks/1
  # # DELETE /tasks/1.xml
  # def destroy
  #   @task = Task.find(params[:id])
  #   @task.destroy

  #   respond_to do |format|
  #     format.xml  { head :ok }
  #   end
  # end

  private

  def type_to_worker(type)
    "#{type}_worker".to_sym
  end

  def job_key
    params[:task][:parameters].to_s
  end
end
