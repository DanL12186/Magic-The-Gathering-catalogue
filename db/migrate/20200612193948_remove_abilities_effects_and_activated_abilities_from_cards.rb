class RemoveAbilitiesEffectsAndActivatedAbilitiesFromCards < ActiveRecord::Migration[6.0]
  def change
    remove_column :cards, :abilities, :string, array: true
    remove_column :cards, :activated_abilities, :string, array: true
    remove_column :cards, :effects, :string, array: true
  end
end