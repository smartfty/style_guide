require 'rails_helper'

RSpec.describe "exeprt_writers/edit", type: :view do
  before(:each) do
    @exeprt_writer = assign(:exeprt_writer, ExeprtWriter.create!(
      :name => "MyString",
      :work => "MyString",
      :position => "MyString",
      :email => "MyString",
      :category_code => 1,
      :expert_image => "MyString",
      :expert_jpg_image => "MyString"
    ))
  end

  it "renders the edit exeprt_writer form" do
    render

    assert_select "form[action=?][method=?]", exeprt_writer_path(@exeprt_writer), "post" do

      assert_select "input[name=?]", "exeprt_writer[name]"

      assert_select "input[name=?]", "exeprt_writer[work]"

      assert_select "input[name=?]", "exeprt_writer[position]"

      assert_select "input[name=?]", "exeprt_writer[email]"

      assert_select "input[name=?]", "exeprt_writer[category_code]"

      assert_select "input[name=?]", "exeprt_writer[expert_image]"

      assert_select "input[name=?]", "exeprt_writer[expert_jpg_image]"
    end
  end
end
