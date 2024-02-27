# frozen_string_literal: true

# rook class
class Queen
  attr_accessor :row, :column, :has_moved
  attr_reader :color, :sprite

  def initialize(color, row, column)
    @color = color
    @row = row
    @column = column
    @sprite = color == 'white' ? ' ♕ ' : ' ♛ '
    @has_moved = false
  end

  def valid?(row, column, board)
    valid_destination?(row, column, board) &&
      (valid_diagonal?(row, column, board) ||
      valid_in_row?(row, column, board) ||
      valid_in_column?(row, column, board))
  end

  def valid_diagonal?(row, column, board)
    different_square?(row, column) &&

      (@row - row).abs == (@column - column).abs &&
      clear_between_diagonal?(row, column, board)
  end

  def different_square?(row, column)
    row != @row && @column != column
  end

  def clear_between_diagonal?(row, column, board)
    row_step = @row < row ? 1 : -1
    col_step = @column < column ? 1 : -1

    current_row = @row + row_step
    current_col = @column + col_step

    while current_row != row && current_col != column
      return false unless board[current_row][current_col].nil?

      current_row += row_step
      current_col += col_step
    end

    true
  end

  def valid_destination?(row, column, board)
    board[row][column]&.color != @color
  end

  def valid_in_row?(row, column, board)
    row == @row &&
      @column != column &&
      clear_between_row?(column, board)
  end

  def valid_in_column?(row, column, board)
    column == @column &&
      @row != row &&
      clear_between_column?(row, board)
  end

  def clear_between_row?(column, board)
    min_column, max_column = [@column, column].sort
    (min_column + 1...max_column).all? { |i| board[@row][i].nil? }
  end

  def clear_between_column?(row, board)
    min_row, max_row = [@row, row].sort
    (min_row + 1...max_row).all? { |i| board[i][@column].nil? }
  end

  # just a concept method, later for King moves and check etc, piece threatens all squares it may move to
  def threatens?(row, column, board)
    board.each { |square| square.valid?(row, column, board) }
  end
end
