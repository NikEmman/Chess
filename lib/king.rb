# rubocop:disable Style/EachForSimpleLoop
# frozen_string_literal: true

# rook class
class King
  attr_accessor :row, :column, :has_moved
  attr_reader :color, :sprite

  def initialize(color, row, column)
    @color = color
    @row = row
    @column = column
    @sprite = color == 'white' ? ' ♔ ' : ' ♚ '
    @has_moved = false
  end

  def valid?(row, column, board)
    castling?(row, column, board) ||
      valid_diagonal?(row, column, board) ||
      valid_in_row?(row, column, board) ||
      valid_in_column?(row, column, board)
  end

  def valid_diagonal?(row, column, board)
    (@column - column).abs == 1 &&
      (@row - row).abs == 1 &&
      board[row][column]&.color != @color
  end

  def valid_in_row?(row, column, board)
    row == @row &&
      (@column - column).abs == 1 &&
      board[row][column]&.color != @color
  end

  # not working
  def not_threatened_by_enemy_piece?(row, column, board)
    (0..7).each do |i|
      (0..7).each do |j|
        next if board[i][j].nil? || board[i][j].color == @color
        return false if board[i][j].valid?(row, column, board)
      end
    end
    true
  end

  def valid_in_column?(row, column, board)
    column == @column &&
      (@row - row).abs == 1 &&
      board[row][column]&.color != @color
  end

  def castling?(row, column, board)
    board[@row][@column].color == board[row][column]&.color &&
      board[row][column]&.has_moved == false &&
      @has_moved == false &&
      board[row][column].instance_of?(Rook) &&
      clear_between_row?(column, board)
  end

  def clear_between_row?(column, board)
    min_column, max_column = [@column, column].sort
    (min_column + 1...max_column).all? { |i| board[@row][i].nil? }
  end

  # just a concept method, later for King moves and check etc, piece threatens all squares it may move to
  def threatens?(row, column, board)
    board.each { |square| square.valid?(row, column, board) }
  end
end
# rubocop:enable Style/EachForSimpleLoop
