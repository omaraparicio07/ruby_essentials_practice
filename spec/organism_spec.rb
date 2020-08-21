require "organism"

RSpec.describe Organism do

  context "For an organism with a capacity of 3x3 cells" do

    organism = Organism.new

    it "populates the organism with a group of 3x3 cells" do
      population = [
        [0,0,0],
        [0,1,0],
        [1,0,1]
      ]
      organism.feed population
      expect(organism.cells.count).to eq 9
    end

    it "retrieves the cell at the center and is alive" do
      one_cell = organism.cell_at 1, 1
      expect(one_cell).to eql 1
    end

    it "retrieves the first cell and is not alive" do
      another_cell = organism.cell_at 0, 0
      expect(another_cell).to eql 0
    end

    it "shows the entire organism" do
      current_organism = %{   \n * \n* *\n}
      expect(organism.body).to eq current_organism
    end

    it "containing the cells --- -*- *-* and looking for the cell at 0,0 should have eight neighbors(5 with no life, and 3 alive)" do
      expect(organism.neighbors_at(0,0)).to match_array([0,0,0,1,0,1,0,1])
    end

    it "containing the cells --- -*- *-* and looking for the cell at 0,2 should have eight neighbors(5 with no life, and 3 alive)" do
      expect(organism.neighbors_at(0, 2)).to match_array([0,0,0,1,0,1,0,1])
    end

    it "containing the cells --- -*- *-* and looking for the cell at 2,0 should have eight neighbors(6 with no life, and 2 alive)" do
      expect(organism.neighbors_at(2, 0)).to match_array([0,0,0,0,1,0,0,1])
    end

    it "containing the cells --- -*- *-* and looking for the cell at 2,2 should have eight neighbors(6 with no life, and 2 alive)" do
      expect(organism.neighbors_at(2, 2)).to match_array([0,0,0,0,1,0,1,0])
    end

    it "containing the cells --- -*- *-* and looking for the cell at 0,1 should have eight neighbors(5 with no life, and 3 alive)" do
      expect(organism.neighbors_at(0, 1)).to match_array([0,0,0,1,0,1,0,1])
    end

  end

  context "For a space that is 'populated'" do

    organism = Organism.new

    it "Each cell with one or no neighbors dies, as if by solitude." do
      new_population = [
        [0,0,0],
        [0,1,0],
        [0,0,1]
      ]
      organism.feed new_population
      organism.prepare_to_evolve
      expect(organism.next_generation[1,1]).to eql 0
      expect(organism.next_generation[2,2]).to eql 0
    end

    it "Each cell with four or more neighbors dies, as if by overpopulation." do
      new_population = [
        [1,0,1],
        [0,1,0],
        [1,0,1]
      ]
      organism.feed new_population
      organism.prepare_to_evolve
      expect(organism.next_generation[1,1]).to eql 0
      expect(organism.next_generation[2,2]).to eql 0
    end

    it "Each cell with two or three neighbors survives." do
      new_population = [
        [1,0,1],
        [0,1,0],
        [1,0,1]
      ]
      organism.feed new_population
      organism.prepare_to_evolve
      expect(organism.next_generation[1,1]).to eql 1
      expect(organism.next_generation[2,2]).to eql 1

      new_population = [
        [0,0,0],
        [0,1,0],
        [1,0,1]
      ]
      organism.feed new_population
      organism.prepare_to_evolve
      expect(organism.next_generation[1,1]).to eql 1
      expect(organism.next_generation[2,2]).to eql 1
    end

  end

  context "For a space that is 'empty' or 'unpopulated'" do

    organism = Organism.new

    it "Each cell with three neighbors becomes populated." do
      new_population = [
        [0,1,0],
        [0,0,0],
        [1,0,1]
      ]
      organism.feed new_population
      organism.prepare_to_evolve
      expect(organism.next_generation[1,1]).to eql 1
      expect(organism.next_generation[2,2]).to eql 1
    end
  end

  context "For an organism ready to evolve" do

    organism = Organism.new

    it "evolves the organism one generation" do
      generation_0 = [
        [0,1,0],
        [0,0,0],
        [1,0,1]
      ]
      generation_1 = [
        [1,1,1],
        [1,1,1],
        [1,1,1]
      ]
      organism.feed generation_0
      organism.prepare_to_evolve
      organism.evolve
      expect(organism.cells.to_a).to match_array(generation_1)
    end
  end

end
