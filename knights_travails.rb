class KnightPathFinder
  attr_accessor :position, :visited_positions
  
  def self.valid_moves(pos)
    # pos = [x, y]
    possible_moves = [[1, 2], [2, 1], [2, -1], [1, -2], [-1, -2],
      [-2, -1], [-2, 1], [-1, 2]]
    move_locations = []
    possible_moves.each do |move|
      move_locations << [move[0] + pos[0], move[1] + pos[1]]
    end
    
    move_locations.select do |possible_pos|
      possible_pos[0].between?(0, 7) && possible_pos[1].between?(0, 7)
    end
  end
  
  def initialize(starting_pos)
    @position = starting_pos
    @visited_positions = [starting_pos]
    #build_move_tree
  end  
  
  def build_move_tree
    # def bfs(value)
      until queue.empty?
        current_node = queue.shift
        return current_node if current_node.value == value
        queue += current_node.children
      end
    # end
  end
  
  def new_move_positions(pos)
    
    self.visited_positions += valid_unvisited_moves(pos)
    
  end
  
  private
  
  def valid_unvisited_moves(pos)
    self.class.valid_moves(pos).reject do |move| 
      visited_positions.include?(move)
    end
  end
end




#########################################################
class PolyTreeNode
  attr_accessor :children, :value
  attr_reader :parent
  def initialize(value)
    @parent = nil
    @children = []
    @value = value
  end
  
  def parent=(new_parent)
    parent.children.delete(self) unless self.parent.nil?
    new_parent.children << self unless new_parent.nil?
    @parent = new_parent
    
    # raise "Bad parent=!" unless self.parent == new_parent
    # raise "Bad parent=!" unless new_parent.children.include?(self)
  end
  
  def add_child(child_node)
    child_node.parent = self
  end
  
  def remove_child(child_node)
    raise "Parent does not have this child!" unless self.children.include?(child_node)
    child_node.parent = nil 
  end
  
  def dfs(value)
    # p "before check: self.value: #{self.value} search value: #{value}"
    return self  if self.value == value
 
    self.children.each_with_index do |child, i| 
      final_child = child.dfs(value)
      next if final_child.nil?
      return  final_child
    end
    
    nil
  end
  
  def bfs(value)
    queue = [self]
    until queue.empty?
      current_node = queue.shift
      return current_node if current_node.value == value
      queue += current_node.children
    end
  end
end