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
    move_diagonal?(row, column, board)
  end

  # to_be_tested
  def move_diagonal?(row, column, board)
    row != @row &&
      @column != column &&
      board[row][column]&.color != @color &&
      (@row - row).abs == (@column - column).abs &&
      (board.each_index do |i|
         board[i].each_index do |j|
           next unless (@row - i).abs == (@column - j).abs && (@row..row).include?(i) && (@column..column).include?(j)

           board[i][j].nil?
         end
       end)
  end

  def move_diagonal_right_to_left?(row, column, board); end

  # just a concept method, later for King moves and check etc, piece threatens all squares it may move to
  def threatens?(row, column, board)
    board.each { |square| square.valid?(row, column, board) }
  end
end
