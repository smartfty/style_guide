require 'rails_helper'

RSpec.describe "article_sub_categories/new", type: :view do
  before(:each) do
    assign(:article_sub_category, ArticleSubCategory.new(
      :name => "MyString",
      :code => "MyString"
    ))
  end

  it "renders new article_sub_category form" do
    render

    assert_select "form[action=?][method=?]", article_sub_categories_path, "post" do

      assert_select "input[name=?]", "article_sub_category[name]"

      assert_select "input[name=?]", "article_sub_category[code]"
    end
  end
end
