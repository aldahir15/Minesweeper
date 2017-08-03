class Tile
  attr_accessor :val, :visible, :flagged

  def initialize(val)
    @val = val
    @visible = false
    @flagged = false
  end

  def reveal
    @visible = true
  end

  def change_val(new_val)
    @val = new_val
  end

  def flag
    @flagged = !@flagged
  end

end
