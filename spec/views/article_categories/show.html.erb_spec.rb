require 'rails_helper'

RSpec.describe "article_categories/show", type: :view do
  before(:each) do
    @article_category = assign(:article_category, ArticleCategory.create!(
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
