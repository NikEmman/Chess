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

  def valid_move?(row, column, board, _last_move = [0, 0])
    safe_square?(row, column, board) && valid?(row, column, board)
  end

  def valid?(row, column, board)
    valid_diagonal?(row, column, board) ||
      valid_in_row?(row, column, board) ||
      valid_in_column?(row, column, board) ||
      castling?(row, column, board)
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

  def safe_square?(row, column, board)
    (0..7).each do |i|
      (0..7).each do |j|
        next if board[i][j].nil? || board[i][j].color == @color
        return false if can_reach?(board[i][j], row, column, board)
      end
    end
    true
  end

  def can_reach?(piece, row, column, board)
    if piece.is_a?(King)
      piece.valid?(row, column, board)
    else
      piece.valid_move?(row, column, board)
    end
  end

  # checks if squares moved through by king when castling are not threatened by enemy pieces
  def squares_passed_safe?(column, board)
    range = column > @column ? (@column + 1...column) : (column + 1...@column)

    range.each do |i|
      return false unless board[@row][@column].safe_square?(@row, i, board)
    end

    true
  end

  def valid_in_column?(row, column, board)
    column == @column &&
      (@row - row).abs == 1 &&
      board[row][column]&.color != @color
  end

  def castling?(row, column, board)
    board[row][column].is_a?(Rook) &&
      board[row][column].has_moved == false &&
      @has_moved == false &&
      squares_passed_safe?(column, board) &&
      safe_square?(@row, @column, board) &&
      clear_between_row?(column, board) &&
      board[@row][@column].color == board[row][column].color
  end

  def clear_between_row?(column, board)
    min_column, max_column = [@column, column].sort
    (min_column + 1...max_column).all? { |i| board[@row][i].nil? }
  end
end
# rubocop:enable Style/EachForSimpleLoop
