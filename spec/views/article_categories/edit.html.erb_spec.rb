require 'rails_helper'

RSpec.describe "article_categories/edit", type: :view do
  before(:each) do
    @article_category = assign(:article_category, ArticleCategory.create!(
      :name => "MyString",
      :code => "MyString"
    ))
  end

  it "renders the edit article_category form" do
    render

    assert_select "form[action=?][method=?]", article_category_path(@article_category), "post" do

      assert_select "input[name=?]", "article_category[name]"

      assert_select "input[name=?]", "article_category[code]"
    end
  end
end
