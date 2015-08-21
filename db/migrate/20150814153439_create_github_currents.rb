class CreateGithubCurrents < ActiveRecord::Migration
  def change
    create_table :github_currents do |t|
      t.string :user_name
      t.string :keyword
      t.string :repository
      t.string :file_location 
      t.timestamps null: false
    end
  end
end
