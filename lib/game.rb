# rubocop:disable Metrics/MethodLength
# rubocop:disable Metrics/AbcSize
# rubocop:disable Layout/LineLength
# frozen_string_literal: true

require_relative 'pawn'
require_relative 'rook'
require_relative 'knight'
require_relative 'bishop'
# game class
class Game
  attr_accessor :board, :pieces

  def initialize
    @board = Array.new(8) { Array.new(8) }
    # 0 ['   ', '   ', '   ', '   ', '   ', '   ', '   ', '   '],
    # 1 ['   ', '   ', '   ', '   ', '   ', '   ', '   ', '   '],
    # 2 ['   ', '   ', '   ', '   ', '   ', '   ', '   ', '   '],
    # 3 ['   ', '   ', '   ', '   ', '   ', '   ', '   ', '   '],
    # 4 ['   ', '   ', '   ', '   ', '   ', '   ', '   ', '   '],
    # 5 ['   ', '   ', '   ', '   ', '   ', '   ', '   ', '   '],
    # 6 ['   ', '   ', '   ', '   ', '   ', '   ', '   ', '   '],
    # 7 ['   ', '   ', '   ', '   ', '   ', '   ', '   ', '   ']
  end

  def populate
    # @board[6].each_index do |index|
    #   @board[6][index] = Pawn.new('white', 6, index)
    #   @board[1][index] = Pawn.new('black', 1, index)
    # end
    [0, 7].each do |i|
      @board[7][i] = Rook.new('white', 7, i)
      @board[0][i] = Rook.new('black', 7, i)
    end
    [1, 6].each do |i|
      @board[7][i] = Knight.new('white', 7, i)
      @board[0][i] = Knight.new('black', 7, i)
    end
    [2, 5].each do |i|
      @board[7][i] = Bishop.new('white', 7, i)
      @board[0][i] = Bishop.new('black', 7, i)
    end
  end

  def display_piece(piece)
    piece.nil? ? '   ' : piece.sprite
  end

  def move(row_old, column_old, row_new, column_new)
    return 'Invalid move, try again' unless @board[row_old][column_old]&.valid?(row_new, column_new, @board)

    @board[row_old][column_old].has_moved = true
    temp = @board[row_old][column_old]
    @board[row_old][column_old] = nil
    temp.row = row_new
    temp.column = column_new
    @board[row_new][column_new] = temp
  end

  def display_chessboard
    puts '   1  2  3  4  5  6  7  8 '
    puts "H \e[47m#{display_piece(@board[0][0])}\e[0m\e[100m#{display_piece(@board[0][1])}\e[0m\e[47m#{display_piece(@board[0][2])}\e[0m\e[100m#{display_piece(@board[0][3])}\e[0m\e[47m#{display_piece(@board[0][4])}\e[0m\e[100m#{display_piece(@board[0][5])}\e[0m\e[47m#{display_piece(@board[0][6])}\e[0m\e[100m#{display_piece(@board[0][7])}\e[0m H"
    puts "G \e[100m#{display_piece(@board[1][0])}\e[0m\e[47m#{display_piece(@board[1][1])}\e[0m\e[100m#{display_piece(@board[1][2])}\e[0m\e[47m#{display_piece(@board[1][3])}\e[0m\e[100m#{display_piece(@board[1][4])}\e[0m\e[47m#{display_piece(@board[1][5])}\e[0m\e[100m#{display_piece(@board[1][6])}\e[0m\e[47m#{display_piece(@board[1][7])}\e[0m G"
    puts "F \e[47m#{display_piece(@board[2][0])}\e[0m\e[100m#{display_piece(@board[2][1])}\e[0m\e[47m#{display_piece(@board[2][2])}\e[0m\e[100m#{display_piece(@board[2][3])}\e[0m\e[47m#{display_piece(@board[2][4])}\e[0m\e[100m#{display_piece(@board[2][5])}\e[0m\e[47m#{display_piece(@board[2][6])}\e[0m\e[100m#{display_piece(@board[2][7])}\e[0m F"
    puts "E \e[100m#{display_piece(@board[3][0])}\e[0m\e[47m#{display_piece(@board[3][1])}\e[0m\e[100m#{display_piece(@board[3][2])}\e[0m\e[47m#{display_piece(@board[3][3])}\e[0m\e[100m#{display_piece(@board[3][4])}\e[0m\e[47m#{display_piece(@board[3][5])}\e[0m\e[100m#{display_piece(@board[3][6])}\e[0m\e[47m#{display_piece(@board[3][7])}\e[0m E"
    puts "D \e[47m#{display_piece(@board[4][0])}\e[0m\e[100m#{display_piece(@board[4][1])}\e[0m\e[47m#{display_piece(@board[4][2])}\e[0m\e[100m#{display_piece(@board[4][3])}\e[0m\e[47m#{display_piece(@board[4][4])}\e[0m\e[100m#{display_piece(@board[4][5])}\e[0m\e[47m#{display_piece(@board[4][6])}\e[0m\e[100m#{display_piece(@board[4][7])}\e[0m D"
    puts "C \e[100m#{display_piece(@board[5][0])}\e[0m\e[47m#{display_piece(@board[5][1])}\e[0m\e[100m#{display_piece(@board[5][2])}\e[0m\e[47m#{display_piece(@board[5][3])}\e[0m\e[100m#{display_piece(@board[5][4])}\e[0m\e[47m#{display_piece(@board[5][5])}\e[0m\e[100m#{display_piece(@board[5][6])}\e[0m\e[47m#{display_piece(@board[5][7])}\e[0m C"
    puts "B \e[47m#{display_piece(@board[6][0])}\e[0m\e[100m#{display_piece(@board[6][1])}\e[0m\e[47m#{display_piece(@board[6][2])}\e[0m\e[100m#{display_piece(@board[6][3])}\e[0m\e[47m#{display_piece(@board[6][4])}\e[0m\e[100m#{display_piece(@board[6][5])}\e[0m\e[47m#{display_piece(@board[6][6])}\e[0m\e[100m#{display_piece(@board[6][7])}\e[0m B"
    puts "A \e[100m#{display_piece(@board[7][0])}\e[0m\e[47m#{display_piece(@board[7][1])}\e[0m\e[100m#{display_piece(@board[7][2])}\e[0m\e[47m#{display_piece(@board[7][3])}\e[0m\e[100m#{display_piece(@board[7][4])}\e[0m\e[47m#{display_piece(@board[7][5])}\e[0m\e[100m#{display_piece(@board[7][6])}\e[0m\e[47m#{display_piece(@board[7][7])}\e[0m A"
    puts '   1  2  3  4  5  6  7  8 '
  end
end
# a = Game.new
# a.populate
# a.display_chessboard
# a.move(6, 1, 4, 1)
# a.display_chessboard
# gets
# rubocop:enable Layout/LineLength
# rubocop:enable Metrics/AbcSize
# rubocop:enable Metrics/MethodLength
