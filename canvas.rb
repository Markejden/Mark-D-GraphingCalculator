require 'ruby2d'
require_relative 'equation'
require_relative 'drawing'

class Truepoint
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
        @mid      = Truepoint.new(@width / 2, @height / 2)
        @panx = 0
        @pany = 0
        @objects = []
    end

    def add_object(ob)
        @objects << ob
    end

    def draw_axis
        Drawing.draw_line(0,@mid.y+@pany,@width,@mid.y+@pany,0,'black')
        Drawing.draw_line(@mid.x+@panx,0,@mid.x+@panx,@height,0,'black')
    end

    def plot_everything
        @objects.each do |eq|
            next if !eq.visible 
            objclass = eq.class
            plot_equation(eq) if objclass == Equation
            plot_text(eq) if objclass == Text
            plot_point(eq) if objclass == Point
            plot_line(eq) if objclass == Line
            plot_rectangle(eq) if objclass == Rectangle
        end
    end

    def run
        update do
            @zoom = 1.0+(50.0-((@objects[0].iny)-405.0))/25
            clear
            draw_axis
            plot_everything
        end
        show
    end

    def plot_equation(eq)
        resolution = 1.0 / @zoom
        rangestart = (-@width/@zoom/2)-(@panx/@zoom)
        rangeend = (@width/@zoom/2)-(@panx/@zoom)

        x1 = rangestart
        y1 = eq.evaluate(x1)

        while x1 < rangeend
            x2 = x1 + resolution
            y2 = eq.evaluate(x2)

            unless y1.nil? || y2.nil?
                pixel_jump = (y2 - y1).abs * @zoom
                
                draw = true
                if pixel_jump > @height
                    draw = false
                elsif pixel_jump > 3.0
                    mid_x = (x1 + x2) / 2.0
                    truey = eq.evaluate(mid_x)
                    
                    if truey.nil?
                        draw = false 
                    else
                        expecty = (y1 + y2) / 2.0
                        if (truey - expecty).abs > (y2 - y1).abs * 0.45
                            draw = false
                        end
                    end
                end

                if draw
                    Drawing.draw_line(
                        (x1*@zoom)+@mid.x+@panx, @pany+@mid.y-(y1*@zoom),
                        (x2*@zoom)+@mid.x+@panx, @pany+@mid.y-(y2*@zoom),
                        eq.zindex, eq.color
                    )
                end
            end
            x1 = x2
            y1 = y2
        end
    end

    def plot_text(text)
        Drawing.draw_text(text.content,text.inx,text.iny,text.zindex,text.rot,text.size,text.color)
    end

    def plot_point(point)
        Drawing.draw_point(point.inx, point.iny, point.zindex, point.color,)
    end

    def plot_line(line)
        Drawing.draw_line(line.inx1,line.iny1,line.inx2,line.iny2,line.zindex,line.color)
    end

    def plot_rectangle(rect)
        Drawing.draw_rectangle(rect.inx, rect.iny, rect.wide, rect.high, rect.zindex, rect.color)
    end

    def pan_to(x,y)
        @panx += x
        @pany += y
    end
end