class CreateUploadFiles < ActiveRecord::Migration[8.0]
  def change
    create_table :upload_files do |t|
      t.string :title
      t.text :description
      t.string :shared_url
      t.references :user, index: true

      t.timestamps
    end
  end
end
