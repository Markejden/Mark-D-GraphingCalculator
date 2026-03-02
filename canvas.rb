require 'ruby2d'
require_relative 'equation'
require_relative 'drawing'

class Point
  attr_accessor :x, :y
  def initialize(x, y)
    @x = x
    @y = y
  end
end

class Canvas
    include Ruby2D::DSL
    def initialize
        @width    = get :width
        @height   = get :height
        @mid      = Point.new(@width / 2, @height / 2)
        @equations = []
    end

    def add_equation(equation)
        @equations << equation
    end
    
    def draw_axis
        Drawing.draw_line(0,@mid.y,@width,@mid.y,0,'black')
        Drawing.draw_line(@mid.x,0,@mid.x,@height,0,'black')
    end

    def plot_everything
        @equations.each do |eq|
            next if !eq.visible 
            plot_equation(eq)
        end
    end

    def run
        draw_axis
        plot_everything
        update {}
        show
    end

    
    def plot_equation(eq)
        range = (-@width/2..@width/2)
        y1 = eq.evaluate(range.first)

        range.each_cons(2) do |x1, x2|
        y2 = eq.evaluate(x2)
        Drawing.draw_line(
            x1 + @mid.x, @mid.y - y1,
            x2 + @mid.x, @mid.y - y2,
            0, eq.color
        )
        y1 = y2
        end
    end
end