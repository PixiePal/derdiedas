class RemoveEnglishFromWord < ActiveRecord::Migration
  def self.up
    remove_column :words, :english
  end

  def self.down
    add_column :words, :english, :string
  end
end
