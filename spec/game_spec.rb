# frozen_string_literal: true

require_relative '../lib/game'

describe Game do
  describe '#valid_move_input?' do
    subject(:game_valid_move_input) { described_class.new }
    it 'returns true when is of type xyxy where x is between a and h, and y between 1 and 8.' do
      move_input = 'a3b4'
      expect(game_valid_move_input.valid_move_input?(move_input)).to be_truthy
    end
    it 'returns false when x is not between a and h.' do
      move_input = 'a3z4'
      expect(game_valid_move_input.valid_move_input?(move_input)).to be_falsey
    end
    it 'returns false when y is not between 1 and 8.' do
      move_input = 'a9g7'
      expect(game_valid_move_input.valid_move_input?(move_input)).to be_falsey
    end
    it 'returns false when more than 4 chars long.' do
      move_input = 'a2g71'
      expect(game_valid_move_input.valid_move_input?(move_input)).to be_falsey
    end
  end
end
