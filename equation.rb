class Equation
  attr_accessor :color,:zindex,:visible,:offsetx,:offsety

  def initialize(color: 'black', visible: true, zindex: 0, &formula)
    raise ArgumentError, 'no formula' if !block_given?
    
    @formula = formula
    @color = color
    @visible = visible
    @zindex = zindex
    @offsetx = 0
    @offsety = 0
  end

  def evaluate(x)
    begin
      @formula.call(x)
    rescue => e
      nil
  end

  def toggle
    @visible = !@visible
  end
end

class Text
  attr_accessor :content,:inx,:iny,:size,:rot,:zindex,:color,:visible  
  def initialize(content: 'hej', inx: 0, iny: 0, size: 25, rot: 0, zindex: 0, color: 'black', visible: true)
    @content = content
    @inx = inx
    @iny = iny
    @zindex = zindex
    @size = size
    @rot = rot
    @color = color
    @visible = visible
  end

  def toggle
    @visible = !@visible
  end
end