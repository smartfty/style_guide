require 'rails_helper'

RSpec.describe "article_sub_categories/show", type: :view do
  before(:each) do
    @article_sub_category = assign(:article_sub_category, ArticleSubCategory.create!(
      :name => "Name",
      :code => "Code"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/Code/)
  end
end
