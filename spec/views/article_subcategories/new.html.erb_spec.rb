require 'rails_helper'

RSpec.describe "article_subcategories/new", type: :view do
  before(:each) do
    assign(:article_subcategory, ArticleSubcategory.new(
      :name => "MyString",
      :code => "MyString"
    ))
  end

  it "renders new article_subcategory form" do
    render

    assert_select "form[action=?][method=?]", article_subcategories_path, "post" do

      assert_select "input[name=?]", "article_subcategory[name]"

      assert_select "input[name=?]", "article_subcategory[code]"
    end
  end
end
