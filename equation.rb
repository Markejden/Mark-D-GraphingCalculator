class Equation
  attr_accessor :color,:zindex, :visible

  def initialize(color: 'black', visible: true, zindex: 0, &formula)
    raise ArgumentError, 'no formula' if !block_given?
    
    @formula = formula
    @color = color
    @visible = visible
    @zindex = zindex
  end

  def evaluate(x)
    @formula.call(x)
  rescue => e
    nil
  end

  def toggle!
    @visible = !@visible
  end
end