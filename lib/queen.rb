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
    enemy_piece?(row, column, board) &&
      (valid_diagonal?(row, column, board) ||
      valid_in_row?(row, column, board) ||
      valid_in_column?(row, column, board))
  end

  def valid_diagonal?(row, column, board)
    different_square?(row, column) &&

      (@row - row).abs == (@column - column).abs &&
      diagonal_squares?(row, column, board)
  end

  def different_square?(row, column)
    row != @row && @column != column
  end

  def diagonal_squares?(row, column, board)
    (board.each_index do |i|
       board[i].each_index do |j|
         next unless (@row - i).abs == (@column - j).abs && (@row..row).include?(i) && (@column..column).include?(j)

         board[i][j].nil?
       end
     end)
  end

  def enemy_piece?(row, column, board)
    board[row][column]&.color != @color
  end

  def valid_in_row?(row, column, board)
    row == @row && @column != column &&
      (((1..column - 1).each { |i| board[@row][@column + i].nil? }) ||
      ((1..column - 1).each { |i| board[@row][@column - i].nil? }))
  end

  def valid_in_column?(row, column, board)
    column == @column && @row != row &&
      ((@row + 1..row - 1).each { |i| board[i][@column].nil? } ||
      (@row - 1..row + 1).each { |i| board[i][@column].nil? })
  end

  # just a concept method, later for King moves and check etc, piece threatens all squares it may move to
  def threatens?(row, column, board)
    board.each { |square| square.valid?(row, column, board) }
  end
end
