class CreateURLExtracts < ActiveRecord::Migration[5.2]
  def change
    create_table :url_extracts do |t|
      t.text :content
      t.integer :member_id, foreign_key: true
    end
  end
end
