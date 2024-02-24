# frozen_string_literal: true

# rook class
class Bishop
  attr_accessor :row, :column, :has_moved
  attr_reader :color, :sprite

  def initialize(color, row, column)
    @color = color
    @row = row
    @column = column
    @sprite = color == 'white' ? ' ♗ ' : ' ♝ '
    @has_moved = false
  end

  def valid?(row, column, board)
    enemy_piece?(row, column, board) &&
      valid_diagonal?(row, column, board)
  end

  def valid_diagonal?(row, column, board)
    different_square?(row, column) &&
      (@row - row).abs == (@column - column).abs &&
      diagonal_squares?(row, column, board)
  end

  def different_square?(row, column)
    row != @row && @column != column
  end

  def enemy_piece?(row, column, board)
    board[row][column]&.color != @color
  end

  def diagonal_squares?(row, column, board)
    (board.each_index do |i|
       board[i].each_index do |j|
         next unless (@row - i).abs == (@column - j).abs && (@row..row).include?(i) && (@column..column).include?(j)

         board[i][j].nil?
       end
     end)
  end

  # just a concept method, later for King moves and check etc, piece threatens all squares it may move to
  def threatens?(row, column, board)
    board.each { |square| square.valid?(row, column, board) }
  end
end
