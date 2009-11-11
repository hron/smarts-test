class ArithmometerWorker < BackgrounDRb::MetaWorker
  set_worker_name :arithmometer_worker
  def create(args = nil)
    # this method is called, when worker is loaded for the first time
  end
  
  def sum(args)
    cache[job_key] = args.values.inject(:+)
  end
end

