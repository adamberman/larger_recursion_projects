require_relative 'tic_tac_toe'

class TicTacToeNode
  attr_accessor :board, :next_mover_mark, :prev_move_pos
  
  def initialize(board, next_mover_mark, prev_move_pos = nil)
    @board = board
    @next_mover_mark = next_mover_mark
    @prev_move_pos = prev_move_pos
  end

  def losing_node?(evaluator)
    return board.won? && board.winner != evaluator if board.over?

    if self.next_mover_mark == evaluator
      self.children.all? { |child| child.losing_node?(evaluator) }
    else
      self.children.any? { |child| child.losing_node?(evaluator) }
    end
  end

  def winning_node?(evaluator)
    if board.over?
      return board.won? && board.winner == evaluator
    end

    if self.next_mover_mark == evaluator
      self.children.any? { |child| child.winning_node?(evaluator) }
    else
      self.children.all? { |child| child.winning_node?(evaluator) }
    end
  end

  # This method generates an array of all moves that can be made after
  # the current move.
  def children
    child_nodes = []
    possible_moves = [0, 1, 2].product([0, 1, 2])
    possible_moves.select! do |move| 
      board.empty?(move)
    end
    possible_moves.each do |move|
      new_board = board.dup
      new_board[move] = next_mover_mark
      mark = next_mover_mark == :x ? :o : :x
      child_node = TicTacToeNode.new(new_board, mark, move)
      child_nodes << child_node
    end
    child_nodes
  end
end
