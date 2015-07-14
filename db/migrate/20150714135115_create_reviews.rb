class CreateReviews < ActiveRecord::Migration
  def change
    create_table :reviews do |t|
      t.string     :title
      t.text       :content
      t.integer    :stars
      t.date       :published_at
      t.integer    :walmart_id, index: true
      t.references :product, index: true

      t.timestamps null: false
    end
  end
end