class CreateTeams < ActiveRecord::Migration
  def change
    create_table :teams do |t|
      t.string :name
      t.string :job
      t.string :bio
      t.string :image
      t.timestamps
    end
  end
end
