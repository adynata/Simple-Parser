class CreateTexts < ActiveRecord::Migration
  def change
    create_table :texts do |t|
      t.string :post, null: false
      t.timestamps null: false
    end
  end
end
