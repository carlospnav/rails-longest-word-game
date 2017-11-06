require 'open-uri'

class GameController < ApplicationController
  def index
    @grid = Array.new(8) { (%w[A B C D E F G H I J K L M N O P Q R S T U V W X Y Z]).sample }
  end

  def score
    @result = {}
    attempt = params[:word]
    grid = params[:grid]
    word_result = get_dictionary attempt
    word_result['in_grid'] = check_if_in_grid(grid, attempt)
    @result[:time] = (Time.now - Time.at(params[:start_time].to_i)).round(6)
    @result[:score] = compute_score(@result[:time], attempt, word_result)
    @result[:message] = get_result_message(word_result)
  end

  private

  def get_result_message(word_result)
    if word_result['found'] && word_result['in_grid']
      "Well done"
    elsif !word_result['found']
      "Not an english word"
    else
      "Not in the grid"
    end
  end

  def check_if_in_grid(grid, word)
    reduceable_grid = grid.split(' ')
    word.upcase.split('').each do |letter|
      if reduceable_grid.include?(letter)
        reduceable_grid.delete_at(reduceable_grid.index(letter))
      else
        return false
      end
    end
    true
  end

  def compute_score(time, word, word_result)
    length = word_result['length']
    found = word_result['found']
    result = found ? (100 - (time * 3) + length) : 0
    result = 0 unless word_result['in_grid']
    result
  end

  def get_dictionary(word)
    url = "https://wagon-dictionary.herokuapp.com/#{word}"
    word_result = JSON.parse(open(url).read)
    word_result
  end
end
