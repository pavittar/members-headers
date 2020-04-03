class CreateMembers < ActiveRecord::Migration[5.2]
  def change
    create_table :members do |t|
      t.string :name
      t.text   :website_url
      t.string :website_url_short

      t.timestamps
    end
  end
end
