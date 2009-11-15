# -*- coding: utf-8 -*-
class QuadraticEquactionWorker < BackgrounDRb::MetaWorker
  include Math
  
  set_worker_name :quadratic_equaction_worker
  def create(args = nil)
    # this method is called, when worker is loaded for the first time
  end
  
  def calculate(args = nil)
    cache[job_key] = {
      :answer => "",
      :errors => [],
      :time => 0,
      :description => args[:description] || ""
    }
    started_at = Time.now
    
    # unless we have all parameters and all of them is an integer generate an error
    unless args[:parameters].keys.to_set == ["a","b","c"].to_set
      cache[job_key][:errors] << I18n.t(:quadratic_equaction_errors_arguments_count)
      return
    end

    args[:parameters].each_pair do |k,v|
      begin
        args[:parameters][k] = Integer(v)
      rescue
        cache[job_key][:errors] << I18n.t(:quadratic_equaction_errors_arguments_integer)
        return
      end
    end

    # unless args.values.reject {|i| i.respond_to? "/" }.size == 0
    #   cache[job_key][:errors] << I18n.t(:quadratic_equaction_errors_arguments)
    #   return
    # end
      
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
