# rubocop:disable Style/EachForSimpleLoop
# rubocop:disable Metrics/AbcSize
# rubocop:disable Layout/LineLength
# frozen_string_literal: true

require_relative 'pawn'
# game class
class Game
  attr_accessor :board, :pieces

  def initialize
    @pieces = Array.new(32)
    @board = [['   ', '   ', '   ', '   ', '   ', '   ', '   ', '   '],
              ['   ', '   ', '   ', '   ', '   ', '   ', '   ', '   '],
              ['   ', '   ', '   ', '   ', '   ', '   ', '   ', '   '],
              ['   ', '   ', '   ', '   ', '   ', '   ', '   ', '   '],
              ['   ', '   ', '   ', '   ', '   ', '   ', '   ', '   '],
              ['   ', '   ', '   ', '   ', '   ', '   ', '   ', '   '],
              ['   ', '   ', '   ', '   ', '   ', '   ', '   ', '   '],
              ['   ', '   ', '   ', '   ', '   ', '   ', '   ', '   ']]
  end

  def populate
    (0..7).each do |column|
      @pieces[column] = Pawn.new('white', 6, column)
      @board[@pieces[column].row][@pieces[column].column] = @pieces[column].sprite
      @pieces[column] = Pawn.new('black', 1, column)
      @board[@pieces[column].row][@pieces[column].column] = @pieces[column].sprite
    end
  end

  def display_chessboard
    puts '   1  2  3  4  5  6  7  8 '
    puts "H \e[47m#{@board[0][0]}\e[100m#{@board[0][1]}\e[47m#{@board[0][2]}\e[100m#{@board[0][3]}\e[47m#{@board[0][4]}\e[100m#{@board[0][5]}\e[47m#{@board[0][6]}\e[100m#{@board[0][7]}\e[0m H"
    puts "G \e[100m#{@board[1][0]}\e[0m\e[47m#{@board[1][1]}\e[0m\e[100m#{@board[1][2]}\e[0m\e[47m#{@board[1][3]}\e[0m\e[100m#{@board[1][4]}\e[0m\e[47m#{@board[1][5]}\e[0m\e[100m#{@board[1][6]}\e[0m\e[47m#{@board[1][7]}\e[0m G"
    puts "F \e[47m#{@board[2][0]}\e[100m#{@board[2][1]}\e[47m#{@board[2][2]}\e[100m#{@board[2][3]}\e[47m#{@board[2][4]}\e[100m#{@board[2][5]}\e[47m#{@board[2][6]}\e[100m#{@board[2][7]}\e[0m F"
    puts "E \e[100m#{@board[3][0]}\e[0m\e[47m#{@board[3][1]}\e[0m\e[100m#{@board[3][2]}\e[0m\e[47m#{@board[3][3]}\e[0m\e[100m#{@board[3][4]}\e[0m\e[47m#{@board[3][5]}\e[0m\e[100m#{@board[3][6]}\e[0m\e[47m#{@board[3][7]}\e[0m E"
    puts "D \e[47m#{@board[4][0]}\e[100m#{@board[4][1]}\e[47m#{@board[4][2]}\e[100m#{@board[4][3]}\e[47m#{@board[4][4]}\e[100m#{@board[4][5]}\e[47m#{@board[4][6]}\e[100m#{@board[4][7]}\e[0m D"
    puts "C \e[100m#{@board[5][0]}\e[0m\e[47m#{@board[5][1]}\e[0m\e[100m#{@board[5][2]}\e[0m\e[47m#{@board[5][3]}\e[0m\e[100m#{@board[5][4]}\e[0m\e[47m#{@board[5][5]}\e[0m\e[100m#{@board[5][6]}\e[0m\e[47m#{@board[5][7]}\e[0m C"
    puts "B \e[47m#{@board[6][0]}\e[100m#{@board[6][1]}\e[47m#{@board[6][2]}\e[100m#{@board[6][3]}\e[47m#{@board[6][4]}\e[100m#{@board[6][5]}\e[47m#{@board[6][6]}\e[100m#{@board[6][7]}\e[0m B"
    puts "A \e[100m#{@board[7][0]}\e[0m\e[47m#{@board[7][1]}\e[0m\e[100m#{@board[7][2]}\e[0m\e[47m#{@board[7][3]}\e[0m\e[100m#{@board[7][4]}\e[0m\e[47m#{@board[7][5]}\e[0m\e[100m#{@board[7][6]}\e[0m\e[47m#{@board[7][7]}\e[0m A"
    puts '   1  2  3  4  5  6  7  8 '
  end
end

a = Game.new
a.populate
a.display_chessboard
gets
a.pieces[0].move(5, 0, a.board)
a.populate
a.display_chessboard
gets
# rubocop:enable Layout/LineLength
# rubocop:enable Metrics/AbcSize
# rubocop:enable Style/EachForSimpleLoop
