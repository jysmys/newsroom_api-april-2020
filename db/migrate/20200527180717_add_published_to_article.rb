class AddPublishedToArticle < ActiveRecord::Migration[6.0]
  def change
    add_column :articles, :published, :boolean, default: false
  end
end
