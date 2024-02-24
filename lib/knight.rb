# rubocop:disable Metrics/AbcSize
# rubocop:disable Metrics/CyclomaticComplexity
# frozen_string_literal: true

# rook class
class Knight
  attr_accessor :row, :column, :has_moved
  attr_reader :color, :sprite

  def initialize(color, row, column)
    @color = color
    @row = row
    @column = column
    @sprite = color == 'white' ? ' ♘ ' : ' ♞ '
    @has_moved = false
  end

  def valid?(row, column, board)
    row != @row &&
      @column != column &&
      board[row][column]&.color != @color &&
      (((@row - row).abs == 1 && (@column - column).abs == 2) || ((@row - row).abs == 2 && (@column - column).abs == 1))
  end

  # just a concept method, later for King moves and check etc, piece threatens all squares it may move to
  def threatens?(row, column, board)
    board.each { |square| square.valid?(row, column, board) }
  end
end
# rubocop:enable Metrics/CyclomaticComplexity
# rubocop:enable Metrics/AbcSize
