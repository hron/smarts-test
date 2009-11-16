module Calcbox
  module WorkerHelpers
    def self.included(base)
      base.class_eval do

        private
        
        def init_cache(args)
          cache[job_key] = {
            :answer => "",
            :errors => [],
            :time => 0,
            :description => args[:description] || ""
          }
        end

        def ensure_parameters_count(args, p)
          # unless we have all parameters and all of them is an integer generate an error
          unless args[:parameters].keys.to_set == p.to_set
            cache[job_key][:errors] << I18n.t(:quadratic_equaction_errors_arguments_count)
            return false
          end
          return true
        end

        def ensure_parameters_integers(args)
          args[:parameters].each_pair do |k,v|
            begin
              args[:parameters][k] = Integer(v)
            rescue
              cache[job_key][:errors] << I18n.t(:quadratic_equaction_errors_arguments_integer)
              return false
            end
          end
          return true
        end

        def calculate_time started_at
          cache[job_key][:time] = Time.now - started_at
        end
      end
    end
  end
end
