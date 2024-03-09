# rubocop:disable Metrics/MethodLength
# frozen_string_literal: true

require_relative './lib/game'
require 'pry-byebug'

# create save/load game methods

# fix display pieces taken next to board

# main class
class Main
  attr_accessor :game

  def initialize
    @game = Game.new
  end

  def play
    loop do
      @game.play
      if @game.input == 'save'
        game_save
      elsif @game.input == 'load'
        @game = game_load
      end
      announce_game_result(@game)
      check_restart(@game)
      break if @game.input == 'exit' || %w[Win Draw].include?(@game.game_result)
    end
  end

  def announce_game_result(game)
    if game.game_result == 'Win'
      puts "It is a win for #{game.winner}!!!"
    elsif game.game_result == 'Draw'
      puts "What a game! It's a draw!!"
    end
  end

  def game_save
    File.write('save00.yml', YAML.dump(@game))
  end

  def game_load
    YAML.load_file('save00.yml', permitted_classes: [Game, Rook, Pawn, Queen, Bishop, King, Knight])
  end

  def check_restart(game)
    return unless %w[Win,Draw].include?(game.game_result)

    puts 'Do you want to play again? [Y/N] :'
    answer = gets.chomp.downcase
    return unless answer == 'y'

    @game = Game.new
  end
end
# rubocop:enable Metrics/MethodLength
