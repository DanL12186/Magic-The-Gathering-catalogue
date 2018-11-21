class AddHiResImageAndCroppedImageUrlColumnToCards < ActiveRecord::Migration[5.2]
  def change
    add_column :cards, :hi_res_img, :string
    add_column :cards, :cropped_img, :string
  end
end
