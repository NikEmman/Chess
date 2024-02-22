# rubocop:disable Metrics/AbcSize
# frozen_string_literal: true

# rook class
class Rook
  attr_accessor :row, :column, :has_moved
  attr_reader :color, :sprite

  def initialize(color, row, column)
    @color = color
    @row = row
    @column = column
    @sprite = color == 'white' ? ' ♖ ' : ' ♜ '
    @has_moved = false
  end

  # neither validation is working
  def valid?(row, column, board)
    move_in_row?(row, column, board) ||
      move_in_column?(row, column, board)
  end

  def valid_2?(row, column, board)
    move_in_row_2?(row, column, board) ||
      move_in_column_2?(row, column, board)
  end

  def move_in_row?(row, column, board)
    row == @row &&
      ((1..column).all? { |i| board[@row][column + i].nil? }) ||
      ((1..column).all? { |i| board[@row][column - i].nil? }) ||
      (((1..column - 1).all? { |i| board[@row][column + i].nil? }) && board[@row][column].color != @color) ||
      (((1..column - 1).all? { |i| board[@row][column - i].nil? }) && board[@row][column].color != @color)
  end

  def move_in_row_2?(row, column, board)
    return false unless row == @row

    path = (@column...column).map { |i| board[@row][i] }

    path.all?(&:nil?) || (path[0...-1].all?(&:nil?) && path.last.color != @color)
  end

  def move_in_column?(row, column, board)
    column == @column &&
      ((1..row).all? { |i| board[@row + i][column].nil? }) ||
      ((1..row).all? { |i| board[@row - i][column].nil? }) ||
      (((1..row - 1).all? { |i| board[@row + i][column].nil? }) && board[row][column].color != @color) ||
      (((1..row - 1).all? { |i| board[@row - i][column].nil? }) && board[row][column].color != @color)
  end

  def move_in_column_2?(row, column, board)
    return false unless column == @column

    path = (@row...row).map { |i| board[i][@column] }

    path.all?(&:nil?) || (path[0...-1].all?(&:nil?) && path.last.color != @color)
  end

  # just a concept method, later for King moves and check etc
  def threatens?; end
end
# rubocop:enable Metrics/AbcSize
