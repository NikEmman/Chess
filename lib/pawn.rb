# frozen_string_literal: true

# pawn class
class Pawn
  attr_accessor :row, :column
  attr_reader :color, :sprite

  def initialize(color, row, column)
    @color = color
    @row = row
    @column = column
    @sprite = color == 'white' ? ' ♙ ' : ' ♟ '
    @has_moved = false
  end

  def move(target_row, target_column, board)
    @has_moved = true
    return 'Invalid move, try again' unless valid?(target_row, target_column, board)

    @row = target_row
    @column = target_column
  end

  def valid?(row, column, board)
    move_one?(row, column, board) ||
      move_two?(row, column, board) ||
      move_diagonal?(row, column, board)
  end

  def move_one?(row, column, board)
    @color == 'white' && row == @row - 1 && @column == column && board[row][column] == '   '
  end

  def move_two?(row, column, board)
    @color == 'white' && row == @row - 2 && @column == column && board[row][column] == '   ' && @has_moved == false
  end

  def move_diagonal?(row, column, board)
    (row == (@color == 'white' ? @row - 1 : @row + 1)) &&
      (@column == column - 1 || @column == column + 1) &&
      board[row][column].color != @color
  end

  def threatens?(board)
    if @color == 'white'
      board[@row - 1][@column + 1] || board[@row - 1][@column - 1]
    else
      board[@row + 1][@column + 1] || board[@row + 1][@column - 1]
    end
  end
end
