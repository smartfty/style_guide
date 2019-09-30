require 'rails_helper'

RSpec.describe "article_subcategories/index", type: :view do
  before(:each) do
    assign(:article_subcategories, [
      ArticleSubcategory.create!(
        :name => "Name",
        :code => "Code"
      ),
      ArticleSubcategory.create!(
        :name => "Name",
        :code => "Code"
      )
    ])
  end

  it "renders a list of article_subcategories" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "Code".to_s, :count => 2
  end
end
