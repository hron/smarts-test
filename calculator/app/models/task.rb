class Task < ActiveResource::Base
  TYPES = {
    "quadratic_equaction" => [ :a, :b, :c ],
    "line_equaction_from_points" => [ :x1, :y1, :x2, :y2 ]
  }.freeze

  self.site = "http://localhost:4000"

  def to_param
    "#{@attributes["type"]}-#{parameters.to_s}"
  end
end
