class AddPosterIdToPosts < ActiveRecord::Migration[5.0]
  def change
    add_column :posts, :poster_id, :integer
  end
end
