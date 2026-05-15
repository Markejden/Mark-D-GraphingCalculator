require 'ruby2d'
require_relative 'canvas'
require_relative 'actions'
require_relative 'equation'
set title: 'Desmos', background: 'black'
set resizable: true

WIDTH = get :width
HEIGHT = get :height #upcase för global var

dabble = Text.new(content: 'Right click to mark, R to clear',inx: 50, iny: 50, zindex:5, color: 'white', size:15)
dibble = Text.new(content: '? to prompt command',inx: 50, iny: 30, zindex:5, color: 'white', size:15)
slider = Point.new(inx: 40,size:6, iny: HEIGHT-185,zindex:5, color: 'white')
sliderline = Line.new(inx1: 40, iny1: HEIGHT-350, inx2: 40, iny2: HEIGHT-20, zindex:4, color: 'white')
slideroutline = Rectangle.new(inx: 32, iny: HEIGHT-360,wide:16,high:350, zindex:3, color: 'black')
inputbox = Rectangle.new(inx: 80, iny: HEIGHT-20, wide: 100, high: -30, zindex: 4, color: 'white') # 300 ÄR LIKA STORT SOM 27 KARAKTÄRER
box2 = Rectangle.new(inx: 80, iny: HEIGHT-60, wide: 100, high: -30, zindex: 4, color: 'white')
textbox = Text.new(content: '_',inx: 80, iny: HEIGHT-50,zindex:5, color: 'black',size:20)
graf = Equation.new(color: 'red', zindex: 1){|x|x*x}
#skapa alla objects

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
canvas.add_object(box2)
#lägger till objekten i listan i canvas

def cbrtsq(x)
    cbrt(x)**2
end

def cbrt(x)
    x >= 0 ? x**(1.0/3) : -((-x)**(1.0/3))
end
#dessa två funktioner är nödvändiga för att visa lösningar på vissa roten ur värden. jag hade tänkt att göra det till en parsad funktion för att göra den mer användbar
# men det vore mycket arbete för ett egentligen väldigt litet problem.

Actions.slider1(slider)
Actions.pan(canvas)
Actions.check_value(canvas, graf)

#denna funktionen tar text input och omvandlar det till en valid ruby kod som kan köras i equation, eval omvandlar stringen till vanlig kod.
Actions.inputbox(textbox, inputbox) do |input|
  if input.start_with?("?") #om du skriver "? " innan du skriver din funktion kan du behandla koden som en konsol, där den istället behandlar texten som kod istället för inmatning.
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
      next nil unless Actions.valid_ruby?(input) #kollar om det är ok att köra koden
      eval(input, binding) rescue nil
    end
  end
  puts input
end

canvas.run

#cbrtsq(x)+Math.sin(30*x)*Math.sqrt(8-x**2)