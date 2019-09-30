require 'rails_helper'

RSpec.describe "article_subcategories/edit", type: :view do
  before(:each) do
    @article_subcategory = assign(:article_subcategory, ArticleSubcategory.create!(
      :name => "MyString",
      :code => "MyString"
    ))
  end

  it "renders the edit article_subcategory form" do
    render

    assert_select "form[action=?][method=?]", article_subcategory_path(@article_subcategory), "post" do

      assert_select "input[name=?]", "article_subcategory[name]"

      assert_select "input[name=?]", "article_subcategory[code]"
    end
  end
end
