# -*- coding: utf-8 -*-
class QuadraticEquactionWorker < BackgrounDRb::MetaWorker
  include Math
  include Calcbox::WorkerHelpers
  
  set_worker_name :quadratic_equaction_worker
  def create(args = nil)
    # this method is called, when worker is loaded for the first time
  end
  
  def calculate(args = nil)
    started_at = Time.now
    init_cache(args)
    return unless ensure_parameters_count(args, [ "a","b","c" ])
    return unless ensure_parameters_integers(args)

    a = args[:parameters]["a"]
    b = args[:parameters]["b"]
    c = args[:parameters]["c"]

    if a == 0
      if b == 0
        if c == 0
          cache[job_key][:answer] = I18n.t(:quadratic_equaction_answer_any_number) 
        else
          cache[job_key][:answer] = I18n.t(:quadratic_equaction_answer_no_roots)
        end
      else
        cache[job_key][:answer] = "x = #{-c/b}"
      end
    else
      d = b*b - 4*a*c
      r = -b/(2*a)
      if d < 0
        i = sqrt(-d)/(2*a)
        x1 = sprintf("x1 = %g + %g*i", r, i)
        x2 = sprintf("x2 = %g - %g*i", r, i)
        cache[job_key][:answer] = "#{x1}; #{x2}"
      elsif d == 0
        cache[job_key][:answer] = sprintf("x1 = x2 = %g", r)
      else
        root1 = (-b+sqrt(d))/(2*a)
        root2 = c/(a*root1)
        cache[job_key][:answer] = sprintf("x1 = %g; x2 = %g", root1, root2)
      end
    end
    cache[job_key][:time] = Time.now - started_at
  end
end
