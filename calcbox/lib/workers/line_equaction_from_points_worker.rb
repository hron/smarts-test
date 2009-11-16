class LineEquactionFromPointsWorker < BackgrounDRb::MetaWorker
  include Math
  include Calcbox::WorkerHelpers

  set_worker_name :line_equaction_from_points_worker
  def create(args = nil)
    # this method is called, when worker is loaded for the first time
  end

  def calculate(args = nil)
    started_at = Time.now
    init_cache(args)
    return unless ensure_parameters_count(args, [ "x1", "y1", "x2", "y2"])
    return unless ensure_parameters_integers(args)
    
    x1 = Float(args[:parameters]["x1"])
    y1 = Float(args[:parameters]["y1"])
    x2 = Float(args[:parameters]["x2"])
    y2 = Float(args[:parameters]["y2"])

    a = y1 - y2
    b = x2 - x1
    c = (x1-x2)*y1 + (y2-y1)*x1
    # cache[job_key][:answer]  = "y="
    # cache[job_key][:answer] += sprintf("%gx", -a) unless a == 0
    # cache[job_key][:answer] += sprintf("%+g", -c) unless c == 0
    cache[job_key][:answer] += if a == 1
                                 "x"
                               elsif a == -1
                                 "-x"
                               elsif a != 0
                                 sprintf("%gx", a)
                               else
                                 ""
                               end
    cache[job_key][:answer] += if b == 1
                                 (a != 0 ? "+" : "") + "y"
                               elsif b == -1
                                 "-y"
                               elsif b != 0
                                 sprintf("%+gy", b)
                               else
                                 ""
                               end
    cache[job_key][:answer] += sprintf("%+g", c) unless c == 0
    cache[job_key][:answer] += "=0"
    calculate_time started_at
  end
end

