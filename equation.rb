class Equation
  attr_accessor :color,:zindex,:visible 

  def initialize(color: 'black', visible: true, zindex: 0, &formula)
    raise ArgumentError, 'no formula' if !block_given?
    
    @formula = formula
    @color = color
    @visible = visible
    @zindex = zindex
  end

  def evaluate(x)
    begin
      @formula.call(x)
    rescue Exception
      nil
    end
  end

  def toggle
    @visible = !@visible
  end

  def set_formula(&block)
    @formula = block
  end

  def self.timestwo(x)
    x*2
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

class Point
  attr_accessor :inx, :iny, :zindex, :color, :visible
  def initialize(inx: 0, iny: 0, zindex: 0, color: 'black', visible: true)
    @inx = inx
    @iny = iny
    @zindex = zindex
    @color = color
    @visible = visible
  end

  def toggle
    @visible = !@visible
  end
end

class Line
  attr_accessor :inx1, :iny1, :inx2,:iny2, :zindex, :color, :visible
  def initialize(inx1: 0, iny1: 0,inx2: 0, iny2: 0, zindex: 0, color: 'black', visible: true)
    @inx1 = inx1
    @iny1 = iny1    
    @inx2 = inx2
    @iny2 = iny2
    @zindex = zindex
    @color = color
    @visible = visible
  end

  def toggle
    @visible = !@visible
  end
end

class Rectangle
  attr_accessor :inx, :iny, :wide, :high, :zindex, :color, :visible
  def initialize(inx: 0, iny: 0, wide: 5, high: 5, zindex: 0, color: 'black', visible: true)
    @inx = inx
    @iny = iny
    @wide = wide
    @high = high
    @zindex = zindex
    @color = color
    @visible = visible
  end

  def toggle
    @visible = !@visible
  end
end