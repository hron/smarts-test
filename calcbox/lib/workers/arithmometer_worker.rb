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

  # program sq;
  # uses
  #   SysUtils, Math;
  # var a, b, c, d, r, i : real;
  # begin
  #   WriteLn ('Equation: A*x*x + B*x + C = 0');
  #    Write ('Input A, B, C: ');
  #    ReadLn (a, b, c);
  #     if a = 0
  #       then
  #         begin
  #         if b = 0
  #           then
  #             begin
  #              if c = 0
  #               then
  #                 begin //Все коэффициенты равны нулю
  #                 WriteLn ('The root of the equation is any number.')
  #                 end
  #                else
  #                 begin //Нет корней - это когда есть только с
  #                 WriteLn ('The equation has no roots.')
  #                 end;
  #             end
  #            else
  #             begin    //Линейное уравнение (а=0, b<>0)
  #             WriteLn ('x=', (-c/b):2:2);
  #             end;
  #         end
  #       else
  #         begin
  #         d := b*b - 4*a*c;//Вычисление дискриминанта
  #         r := -b/(2*a);   //Вычисление действительной части
  #           if d >= 0
  #             then
  #               begin
  #                if d > 0
  #                   then
  #                     begin //Пихаем в i корень х1 - нечего ей простаивать!
  #                     i := -(b + Sign(b)*Sqrt(d))/(2*a);
  #                           //2 корень - по теореме Виета
  #                     WriteLn ('x1=', i:2:2,' x2=', c/(a*i):2:2);
  #                     end
  #                   else
  #                     begin
  #                     WriteLn ('x1=x2=', r:2:2);
  #                     end;
  #                   end
  #             else
  #               begin //Теперь используем i по назначению - для определения
  #                     //коэффициента при мнимой единице
  #                  i := Sqrt(-d)/(2*a);
  #                  WriteLn('x1=', r:2:2, '+ i*', i:2:2, ' x2=', r:2:2, '- i*', i:2:2);
  #               end
  #             end;
  #   ReadLn;
  # end.
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
      if d == 0
        i = sqrt(-d)/(2*a)
        cache[job_key][:answer] = sprintf( "x1 = %.2d + i*%.2d; x2 = %.2d - i*%.2d", r, i, r, i)
      end
    end
  end

end
