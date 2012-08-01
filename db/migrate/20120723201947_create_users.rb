class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :provider
      t.string :uid
      t.string :oauth_token
      t.datetime :oauth_expires_at
      t.string :user_name
      t.string :first_name
      t.string :middle_name
      t.string :last_name
      t.string :location
      t.integer :zip_code
      t.string :email
      t.text :bio
      t.string :thumb_image
      t.date :birth_date
      t.integer :gender
      t.boolean :paid, :default => false
      t.boolean :active, :default => false

      t.timestamps
    end
  end
end
