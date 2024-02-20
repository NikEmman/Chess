# rubocop:disable Metrics/AbcSize
# rubocop:disable Layout/LineLength
# frozen_string_literal: true

# game class
class Game
  attr_accessor :board

  def initialize
    @board = Array.new(64, '   ')
  end

  def display_chessboard
    puts '   1  2  3  4  5  6  7  8 '
    puts "H \e[47m#{@board[56]}\e[100m#{@board[57]}\e[47m#{@board[58]}\e[100m#{@board[59]}\e[47m#{@board[60]}\e[100m#{@board[61]}\e[47m#{@board[62]}\e[100m#{@board[63]}\e[0m H"
    puts "G \e[100m#{@board[48]}\e[0m\e[47m#{@board[49]}\e[0m\e[100m#{@board[50]}\e[0m\e[47m#{@board[51]}\e[0m\e[100m#{@board[52]}\e[0m\e[47m#{@board[53]}\e[0m\e[100m#{@board[54]}\e[0m\e[47m#{@board[55]}\e[0m G"
    puts "F \e[47m#{@board[40]}\e[100m#{@board[41]}\e[47m#{@board[42]}\e[100m#{@board[43]}\e[47m#{@board[44]}\e[100m#{@board[45]}\e[47m#{@board[46]}\e[100m#{@board[47]}\e[0m F"
    puts "E \e[100m#{@board[32]}\e[0m\e[47m#{@board[33]}\e[0m\e[100m#{@board[34]}\e[0m\e[47m#{@board[35]}\e[0m\e[100m#{@board[36]}\e[0m\e[47m#{@board[37]}\e[0m\e[100m#{@board[38]}\e[0m\e[47m#{@board[39]}\e[0m E"
    puts "D \e[47m#{@board[24]}\e[100m#{@board[25]}\e[47m#{@board[26]}\e[100m#{@board[27]}\e[47m#{@board[28]}\e[100m#{@board[29]}\e[47m#{@board[30]}\e[100m#{@board[31]}\e[0m D"
    puts "C \e[100m#{@board[16]}\e[0m\e[47m#{@board[17]}\e[0m\e[100m#{@board[18]}\e[0m\e[47m#{@board[19]}\e[0m\e[100m#{@board[20]}\e[0m\e[47m#{@board[21]}\e[0m\e[100m#{@board[22]}\e[0m\e[47m#{@board[23]}\e[0m C"
    puts "B \e[47m#{@board[8]}\e[100m#{@board[9]}\e[47m#{@board[10]}\e[100m#{@board[11]}\e[47m#{@board[12]}\e[100m#{@board[13]}\e[47m#{@board[14]}\e[100m#{@board[15]}\e[0m B"
    puts "A \e[100m#{@board[0]}\e[0m\e[47m#{@board[1]}\e[0m\e[100m#{@board[2]}\e[0m\e[47m#{@board[3]}\e[0m\e[100m#{@board[4]}\e[0m\e[47m#{@board[5]}\e[0m\e[100m#{@board[6]}\e[0m\e[47m#{@board[7]}\e[0m A"
    puts '   1  2  3  4  5  6  7  8 '
  end
end
# rubocop:enable Layout/LineLength
# rubocop:enable Metrics/AbcSize
