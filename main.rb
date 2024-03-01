# frozen_string_literal: true

require_relative './lib/game'

# create save/load game methods

# fix display pieces taken next to board

# main class
class Main
  attr_accessor :game

  def initialize
    @game = Game.new
  end

  def play
    @game.play
    if @game.input == 'save'
      game_save
    elsif @game.input == 'load'
      @game = game_load
      @game.play
    end
    check_restart(@game.input)
  end

  def game_save
    File.write('save00.yml', YAML.dump(@game))
  end

  def game_load
    YAML.load_file('save00.yml', permitted_classes: [Game])
  end

  def check_restart(input)
    return unless %w[resign draw].include?(input) || @game.valid_action_input?(input)

    puts 'Do you want to play again? [Y/N] :'
    answer = gets.chomp.downcase
    return unless answer == 'y'

    @game = Game.new
    @game.play
  end
end
