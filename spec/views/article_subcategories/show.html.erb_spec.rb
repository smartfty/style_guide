require 'rails_helper'

RSpec.describe "article_subcategories/show", type: :view do
  before(:each) do
    @article_subcategory = assign(:article_subcategory, ArticleSubcategory.create!(
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
