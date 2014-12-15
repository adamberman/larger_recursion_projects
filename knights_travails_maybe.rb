class KnightPathFinder
  attr_accessor :position, :visited_positions
  
  def self.valid_moves(pos)
    possible_moves = [
      [1, 2], [2, 1],
      [2, -1], [1, -2],
      [-1, -2], [-2, -1],
      [-2, 1], [-1, 2]
    ]
    
    move_locations = []
    possible_moves.each do |move|
      move_locations << [move[0] + pos[0], move[1] + pos[1]]
    end
    
    move_locations.select do |possible_pos|
      possible_pos[0].between?(0, 7) && possible_pos[1].between?(0, 7)
    end
  end
  
  def initialize(starting_pos)
    @position = PolyTreeNode.new(starting_pos)
    @visited_positions = [starting_pos]
    build_move_tree
  end  
  
  def build_move_tree
    move_queue = [position]
    until move_queue.empty?
      current_node = move_queue.shift
        # return current_node if current_node.value == value
      new_moves = new_move_positions(current_node.value)
       
      new_moves.each do |new_move|
        current_node.add_child(PolyTreeNode.new(new_move))
      end
      
      move_queue += current_node.children
    end
    
  end
  
  def new_move_positions(pos)
    new_moves = valid_unvisited_moves(pos)
    self.visited_positions += new_moves
    new_moves
  end
  
  def find_path(end_pos)
    end_node = position.bfs(end_pos)
    end_node.trace_path_back.reverse
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
    unless self.children.include?(child_node)
      raise "Parent does not have this child!" 
    end
    child_node.parent = nil 
  end
  
  def dfs(value)
    # p "before check: self.value: #{self.value} search value: #{value}"
    return self if self.value == value
 
    self.children.each do |child| 
      search_result = child.dfs(value)
      next if search_result.nil?
      return search_result
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
  
  def trace_path_back
    current_node = self
    path = [value]
    until current_node.parent.nil?
      current_node = current_node.parent
      path << current_node.value
    end
    
    path
  end
end


kpf = KnightPathFinder.new([0,0])
p kpf.find_path([7,6])
