require 'ruby2d'
require_relative 'canvas'
require_relative 'actions'
require_relative 'equation'
set title: 'Desmos', background: 'black'
set resizable: true

col = 'black'
WIDTH = get :width
HEIGHT = get :height

dabble = Text.new(content: 'Ruby',inx: 50, iny: 50, zindex:5, color: 'white')
dibble = Text.new(content: 'Mark',inx: 50, iny: 30, zindex:5, color: 'white')
slider = Point.new(inx: 40,size:6, iny: HEIGHT-25,zindex:5, color: 'white')
sliderline = Line.new(inx1: 40, iny1: HEIGHT-350, inx2: 40, iny2: HEIGHT-20, zindex:4, color: 'white')
slideroutline = Rectangle.new(inx: 32, iny: HEIGHT-360,wide:16,high:350, zindex:3, color: 'black')
inputbox = Rectangle.new(inx: 80, iny: HEIGHT-20, wide: 100, high: -30, zindex: 4, color: 'white') # 300 ÄR LIKA STORT SOM 27 KARAKTÄRER
textbox = Text.new(content: '_',inx: 80, iny: HEIGHT-50,zindex:5, color: 'black',size:20)
graf = Equation.new(color: 'red', zindex: 1){|x|x*x}

canvas = Canvas.new

canvas.add_object(slider)
canvas.zoomslide = slider

canvas.add_object(graf)

canvas.add_object(dibble)
canvas.add_object(dabble)
canvas.add_object(textbox)
canvas.add_object(sliderline)
canvas.add_object(slideroutline)
canvas.add_object(inputbox)

Actions.slider1(slider)
Actions.pan(canvas)

def cbrtsq(x)
    cbrt(x)**2
end

def cbrt(x)
    x >= 0 ? x**(1.0/3) : -((-x)**(1.0/3))
end
def pow(x, exp)
  if x < 0 && exp.is_a?(Float)
    r = exp.rationalize(0.01)
    r.denominator.odd? ? -((-x)**exp) : nil
  else
    result = x**exp
    result.is_a?(Complex) ? nil : result
  end
end
Actions.inputbox(textbox, inputbox) do |input|
  if input.start_with?("?")
    newin = input.sub(/^\?\s*/, "")
    begin
      eval(newin, binding)
      puts newin
    rescue => e
      puts "#{e.message}"
    end
    next nil
  else
    graf.set_formula do |x|
      next nil unless Actions.valid_ruby?(input)
      eval(input, binding) rescue nil
    end
  end
  puts input
end

canvas.run

#cbrtsq(x)+Math.sin(30*x)*Math.sqrt(8-x**2)