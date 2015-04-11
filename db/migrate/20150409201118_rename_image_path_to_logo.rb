class RenameImagePathToLogo < ActiveRecord::Migration
  def change
    rename_column :teams, :image_path, :logo
  end
end
