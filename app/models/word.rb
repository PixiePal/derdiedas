class Word < ActiveRecord::Base
  has_many :correct_answers
  has_many :mistakes
  
  def self.count_cache
    @@count_cache ||= Word.count
  end
  
  def <=> (o)
    self.german <=> o.german
  end
end
