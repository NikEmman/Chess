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
    (enemy_piece?(row, column, board) || castling?(row, column, board)) &&
      (move_in_row?(row, column, board) ||
        move_in_column?(row, column, board))
  end

  def move_in_row?(row, column, board)
    row == @row && @column != column &&
      (((1..column - 1).each { |i| board[@row][@column + i].nil? }) ||
      ((1..column - 1).each { |i| board[@row][@column - i].nil? }))
  end

  def move_in_column?(row, column, board)
    column == @column && @row != row &&
      ((@row + 1..row - 1).each { |i| board[i][@column].nil? } ||
      (@row - 1..row + 1).each { |i| board[i][@column].nil? })
  end

  def enemy_piece?(row, column, board)
    board[row][column]&.color != @color
  end

  def castling?(row, column, board)
    board[@row][@column].color == board[row][column].color &&
      board[row][column].has_moved == false &&
      @has_moved == false
  end

  # 0  6 ->1,5  ->      ------          6 , 0 -> 5,1
  # just a concept method, later for King moves and check etc, piece threatens all squares it may move to
  def threatens?(row, column, board)
    board.each { |square| square.valid?(row, column, board) }
  end
end
