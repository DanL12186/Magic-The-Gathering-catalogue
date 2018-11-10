class AddSiteNoteColumnToCards < ActiveRecord::Migration[5.2]
  def change
    add_column :cards, :site_note, :text, timestamps: true
  end
end
