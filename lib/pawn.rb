# rubocop:disable Metrics/AbcSize
# frozen_string_literal: true

# pawn class
class Pawn
  attr_accessor :row, :column, :has_moved, :en_passant
  attr_reader :color, :sprite

  def initialize(color, row, column)
    @color = color
    @row = row
    @column = column
    @sprite = color == 'white' ? ' ♙ ' : ' ♟ '
    @has_moved = false
    @en_passant = false
  end

  def valid_move?(row, column, board, last_move)
    en_passant?(row, column, board, last_move) ||
      move_one?(row, column, board) ||
      move_two?(row, column, board) ||
      move_diagonal?(row, column, board)
  end

  def move_one?(row, column, board)
    (row == (@color == 'white' ? @row - 1 : @row + 1)) &&
      @column == column &&
      board[row][column].nil?
  end

  def move_two?(row, column, board)
    (row == (@color == 'white' ? @row - 2 : @row + 2)) &&
      @column == column && board[row][column].nil? &&
      @has_moved == false
  end

  def move_diagonal?(row, column, board)
    return if board[row][column].nil?

    (row == (@color == 'white' ? @row - 1 : @row + 1)) &&
      (@column == column - 1 || @column == column + 1) &&
      board[row][column].color != @color
  end

  def en_passant?(row, column, board, last_move)
    piece = board[@row][@column]
    direction = column > @column ? 1 : -1
    enemy_piece = board[@row][@column + direction]
    destination = board[row][column]

    enemy_piece.is_a?(Pawn) &&
      piece.color != enemy_piece.color &&
      enemy_piece.en_passant == true &&
      (@row - row).abs == 1 &&
      (column - @column).abs == 1 &&
      destination.nil? &&
      last_move == [enemy_piece.row, enemy_piece.column]
  end
end
# rubocop:enable Metrics/AbcSize
