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

  def valid_move?(row, column, board)
    row != @row &&
      @column != column &&
      board[row][column]&.color != @color &&
      (((@row - row).abs == 1 && (@column - column).abs == 2) || ((@row - row).abs == 2 && (@column - column).abs == 1))
  end
end
# rubocop:enable Metrics/CyclomaticComplexity
# rubocop:enable Metrics/AbcSize
