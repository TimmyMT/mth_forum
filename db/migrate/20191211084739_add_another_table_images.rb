class AddAnotherTableImages < ActiveRecord::Migration[5.2]
  def up
    change_table :post_images do |t|
      t.references :post_imageble, polymorphic: true
      t.remove_references :post
    end
  end

  def down
    change_table :post_images do |t|
      t.references :post, index: true
      t.remove_references :post_imageble, polymorphic: true
    end
  end
end
