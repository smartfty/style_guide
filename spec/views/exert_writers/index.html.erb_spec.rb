require 'rails_helper'

RSpec.describe "exert_writers/index", type: :view do
  before(:each) do
    assign(:exert_writers, [
      ExertWriter.create!(
        :name => "Name",
        :work => "Work",
        :position => "Position",
        :email => "Email",
        :category_code => 2,
        :expert_image => "Expert Image",
        :expert_jpg_image => "Expert Jpg Image"
      ),
      ExertWriter.create!(
        :name => "Name",
        :work => "Work",
        :position => "Position",
        :email => "Email",
        :category_code => 2,
        :expert_image => "Expert Image",
        :expert_jpg_image => "Expert Jpg Image"
      )
    ])
  end

  it "renders a list of exert_writers" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "Work".to_s, :count => 2
    assert_select "tr>td", :text => "Position".to_s, :count => 2
    assert_select "tr>td", :text => "Email".to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => "Expert Image".to_s, :count => 2
    assert_select "tr>td", :text => "Expert Jpg Image".to_s, :count => 2
  end
end
