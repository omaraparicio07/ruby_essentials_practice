require "matrix"
require "colorize"

class Organism

  attr_accessor :cells, :next_generation, :cell_colors
  NEW_LINE = "\n"

  def initialize

  end

  def feed(population)
    @cells = Matrix.rows population
    @next_generation = Matrix.rows population
    colors = []
    population.each do |line|
      colors << line.collect do |c| c == 0 ? :black : :green end
    end
    @cell_colors = colors
    self
  end

  def cell_at(x, y)
    @cells[x,y]
  end

  def neighbors_at(posx,posy)
    neighbors = []
    (posx-1..posx+1).each do |x|
      (posy-1..posy+1).each do |y|
        if not(posx == x && posy == y)
          neighbors << @cells[ x < @cells.row_size ? x : 0,  y < @cells.column_size ? y : 0 ]
        end
      end
    end
    neighbors
  end

  def prepare_to_evolve
    local_cells = @next_generation.to_a
    @cells.each_with_index do |c, x, y|
      neighbors = neighbors_at x, y
      case
      when c == 1
        local_cells[x][y] = 0 if neighbors.count(1)  <= 1 # 1
        local_cells[x][y] = 0 if neighbors.count(1)  >= 4 # 2
        #local_cells[x][y] = 1 if(neighbors.count(1)  >= 2 and neighbors.count 1 <= 3)# 3
      else
        local_cells[x][y] = 1 if neighbors.count(1)  == 3 #4
      end
    end
    @next_generation = Matrix.rows local_cells
  end

  def evolve
    @cells = @next_generation
  end

  def body
    display = ""
    @cells.each_with_index do |e, row, col|
      display += e == 1 ? "*" : " "
      display += NEW_LINE if ((col+1) % @cells.column_count) == 0
    end
    display
  end

  def body_with_colors
    display = ""
    @cells.each_with_index do |e, row, col|
      if e == 1 then
        display += "*".colorize(@cell_colors[row][col])
      else
        display += " ".colorize(@cell_colors[row][col])
      end
      display += NEW_LINE if ((col+1) % @cells.column_count) == 0
    end
    display
  end

end
