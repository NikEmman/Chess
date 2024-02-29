# rubocop:disable Metrics/MethodLength
# rubocop:disable Metrics/AbcSize
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

  def valid_move?(row, column, board, _last_move)
    move_safe?(row, column, board) && valid?(row, column, board)
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
    last_move = []
    (0..7).each do |i|
      (0..7).each do |j|
        next if board[i][j].nil? || board[i][j].color == @color
        return false if if board[i][j].is_a?(King)
                          king_valid_move?(i, j, row, column, board)
                        else
                          board[i][j].valid_move?(row, column, board, last_move)
                        end
      end
    end
    true
  end

  def king_valid_move?(i, j, row, column, board)
    board[i][j].valid?(row, column, board) && board[i][j].safe_square?(row, column, board)
  end

  # checks if squares moved through by king when moving or castling are not threatened by enemy pieces
  def squares_passed_safe?(column, board)
    range = column > @column ? (@column + 1...column) : (column + 1...@column)

    range.each do |i|
      return false unless board[@row][@column].safe_square?(@row, i, board)
    end

    true
  end

  def move_safe?(row, column, board)
    if (@column - column).abs > 1
      squares_passed_safe?(column, board)
    else
      safe_square?(row, column, board)
    end
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
      safe_square?(@row, @column, board) &&
      clear_between_row?(column, board) &&
      board[@row][@column].color == board[row][column].color
  end

  def clear_between_row?(column, board)
    min_column, max_column = [@column, column].sort
    (min_column + 1...max_column).all? { |i| board[@row][i].nil? }
  end
end
# rubocop:enable Metrics/AbcSize
# rubocop:enable Metrics/MethodLength
