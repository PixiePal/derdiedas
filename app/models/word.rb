class Word < ActiveRecord::Base
  has_many :correct_answers
  has_many :mistakes
  
  @@count_cache = Word.count
  
  def self.count_cache
    @@count_cache
  end
end
