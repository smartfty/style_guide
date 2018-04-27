class AddOpinionImageToOpinionWriter < ActiveRecord::Migration[5.1]
  def change
    add_column :opinion_writers, :opinion_image, :string
  end
end
