# Player class to hold player name, score and game information
module Hangman
  class Player
    attr_reader :name
    attr_accessor :current_progress, :score
    def initialize(name)
      @name = name
      @score = 0
    end
  end
end