require 'test_helper'

class ImageTemplatesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @image_template = image_templates(:one)
  end

  test "should get index" do
    get image_templates_url
    assert_response :success
  end

  test "should get new" do
    get new_image_template_url
    assert_response :success
  end

  test "should create image_template" do
    assert_difference('ImageTemplate.count') do
      post image_templates_url, params: { image_template: { caption: @image_template.caption, caption_title: @image_template.caption_title, column: @image_template.column, height_in_lines: @image_template.height_in_lines, image_path: @image_template.image_path, position: @image_template.position, row: @image_template.row } }
    end

    assert_redirected_to image_template_url(ImageTemplate.last)
  end

  test "should show image_template" do
    get image_template_url(@image_template)
    assert_response :success
  end

  test "should get edit" do
    get edit_image_template_url(@image_template)
    assert_response :success
  end

  test "should update image_template" do
    patch image_template_url(@image_template), params: { image_template: { caption: @image_template.caption, caption_title: @image_template.caption_title, column: @image_template.column, height_in_lines: @image_template.height_in_lines, image_path: @image_template.image_path, position: @image_template.position, row: @image_template.row } }
    assert_redirected_to image_template_url(@image_template)
  end

  test "should destroy image_template" do
    assert_difference('ImageTemplate.count', -1) do
      delete image_template_url(@image_template)
    end

    assert_redirected_to image_templates_url
  end
end
