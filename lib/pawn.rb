# frozen_string_literal: true

# pawn class
class Pawn
  attr_accessor :row, :column, :has_moved
  attr_reader :color, :sprite

  def initialize(color, row, column)
    @color = color
    @row = row
    @column = column
    @sprite = color == 'white' ? ' ♙ ' : ' ♟ '
    @has_moved = false
  end

  def valid_move?(row, column, board)
    move_one?(row, column, board) ||
      move_two?(row, column, board) ||
      move_diagonal?(row, column, board)
  end

  def move_one?(row, column, board)
    (row == (@color == 'white' ? @row - 1 : @row + 1)) &&
      @column == column &&
      board[row][column].nil?
  end

  def move_two?(row, column, board)
    (row == (@color == 'white' ? @row - 2 : @row + 2)) &&
      @column == column && board[row][column].nil? &&
      @has_moved == false
  end

  def move_diagonal?(row, column, board)
    (row == (@color == 'white' ? @row - 1 : @row + 1)) &&
      (@column == column - 1 || @column == column + 1) &&
      board[row][column].color != @color
  end
end
