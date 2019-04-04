require 'rails_helper'

RSpec.describe "exert_writers/edit", type: :view do
  before(:each) do
    @exert_writer = assign(:exert_writer, ExertWriter.create!(
      :name => "MyString",
      :work => "MyString",
      :position => "MyString",
      :email => "MyString",
      :category_code => 1,
      :expert_image => "MyString",
      :expert_jpg_image => "MyString"
    ))
  end

  it "renders the edit exert_writer form" do
    render

    assert_select "form[action=?][method=?]", exert_writer_path(@exert_writer), "post" do

      assert_select "input[name=?]", "exert_writer[name]"

      assert_select "input[name=?]", "exert_writer[work]"

      assert_select "input[name=?]", "exert_writer[position]"

      assert_select "input[name=?]", "exert_writer[email]"

      assert_select "input[name=?]", "exert_writer[category_code]"

      assert_select "input[name=?]", "exert_writer[expert_image]"

      assert_select "input[name=?]", "exert_writer[expert_jpg_image]"
    end
  end
end
