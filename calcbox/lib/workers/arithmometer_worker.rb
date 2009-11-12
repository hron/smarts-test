# -*- coding: utf-8 -*-
class ArithmometerWorker < BackgrounDRb::MetaWorker
  include Math
  
  set_worker_name :arithmometer_worker
  def create(args = nil)
    # this method is called, when worker is loaded for the first time
  end
  
  def sum(args)
    cache[job_key] = { }
    cache[job_key][:answer] = args.values.inject(:+)
  end

  def resolve_quadratic_equaction(args = nil)
    cache[job_key] = { }
    cache[job_key][:errors] = []

    # unless we have all parameters and all of them is an integer generate an error
    unless args.keys.to_set == [:a,:b,:c].to_set &&
        args.values.reject {|i| i.respond_to? "/" }.size == 0
      cache[job_key][:errors] << I18n.t(:resolve_quadratic_equaction_errors_arguments)
      return
    end

    a = args[:a]
    b = args[:b]
    c = args[:c]

    if a == 0
      if b == 0
        if c == 0
          cache[job_key][:answer] = I18n.t(:resolve_quadratic_equaction_answer_any_number) 
        else
          cache[job_key][:answer] = I18n.t(:resolve_quadratic_equaction_answer_no_roots)
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
  end

end
