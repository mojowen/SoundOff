class CreateOptions < ActiveRecord::Migration
  def change
  	create_table :options do |t|
  		
  		t.string :name
  		t.text :data, :null => false, :default => ''

  	end
  end

end
