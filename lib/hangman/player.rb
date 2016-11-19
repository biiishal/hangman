# Player class to hold player name, score and game information
module Hangman
  class Player
    attr_reader :name, :score
    attr_accessor :current_progress
    def initialize(name)
      @name = name
      @score = 0
    end
  end
end