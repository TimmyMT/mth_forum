class CreateComments < ActiveRecord::Migration[5.2]
  def change
    create_table :comments do |t|
      t.text :body
      t.references :post, index: true , foreign_key: true
      t.references :user, index: true , foreign_key: true

      t.timestamps
    end
  end
end
