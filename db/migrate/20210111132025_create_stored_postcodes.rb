# frozen_string_literal: true

class CreateStoredPostcodes < ActiveRecord::Migration[6.1]
  def change
    create_table :stored_postcodes do |t|
      t.string :postcode, null: false, limit: 8
      t.string :lsoa, null: false
      t.timestamps
    end
    add_index :stored_postcodes, :postcode, unique: true
  end
end
