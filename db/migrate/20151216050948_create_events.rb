class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :title
      t.string :smaller_image
      t.string :image
      t.text :description
      t.timestamps
    end
  end
end
