class CreateCorrectAnswers < ActiveRecord::Migration
  def self.up
    create_table :correct_answers do |t|
      t.integer :word_id
      t.integer :user_id

      t.timestamps
    end
  end

  def self.down
    drop_table :correct_answers
  end
end
