class CreatePartners < ActiveRecord::Migration
  def change
    create_table :partners do |t|
      t.string :name
      t.string :website
      t.string :tax_id
      t.string :partner_type
      t.string :logo

      t.timestamps
    end
  end
end
