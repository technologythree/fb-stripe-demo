class ChangeDataTypeForUserBirthDate < ActiveRecord::Migration
  def up
    change_table :users do |t|
      t.change :birth_date, :datetime
    end
  end

  def down
    change_table :users do |t|
      t.change :birth_date, :date
    end
  end
end
