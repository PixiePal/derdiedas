class CreateMistakes < ActiveRecord::Migration
  def self.up
    create_table :mistakes do |t|
      t.integer :word_id
      t.integer :user_id

      t.timestamps
    end
  end

  def self.down
    drop_table :mistakes
  end
end
