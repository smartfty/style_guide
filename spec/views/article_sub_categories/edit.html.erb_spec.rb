require 'rails_helper'

RSpec.describe "article_sub_categories/edit", type: :view do
  before(:each) do
    @article_sub_category = assign(:article_sub_category, ArticleSubCategory.create!(
      :name => "MyString",
      :code => "MyString"
    ))
  end

  it "renders the edit article_sub_category form" do
    render

    assert_select "form[action=?][method=?]", article_sub_category_path(@article_sub_category), "post" do

      assert_select "input[name=?]", "article_sub_category[name]"

      assert_select "input[name=?]", "article_sub_category[code]"
    end
  end
end
