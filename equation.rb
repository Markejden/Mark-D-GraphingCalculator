class Equation
  attr_accessor :color, :visible

  def initialize(color: 'black', visible: true, &formula)
    raise ArgumentError, 'no formula' if !block_given?
    
    @formula = formula
    @color   = color
    @visible = visible
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