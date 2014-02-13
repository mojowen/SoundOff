class AddCustomCssToPartner < ActiveRecord::Migration
  def change
    add_column :partners, :custom_popup_css, :text
  end
end
