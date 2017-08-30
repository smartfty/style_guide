require 'test_helper'

class AdImagesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @ad_image = ad_images(:one)
  end

  test "should get index" do
    get ad_images_url
    assert_response :success
  end

  test "should get new" do
    get new_ad_image_url
    assert_response :success
  end

  test "should create ad_image" do
    assert_difference('AdImage.count') do
      post ad_images_url, params: { ad_image: { ad_type: @ad_image.ad_type, column: @ad_image.column, page_id: @ad_image.page_number, row: @ad_image.row } }
    end

    assert_redirected_to ad_image_url(AdImage.last)
  end

  test "should show ad_image" do
    get ad_image_url(@ad_image)
    assert_response :success
  end

  test "should get edit" do
    get edit_ad_image_url(@ad_image)
    assert_response :success
  end

  test "should update ad_image" do
    patch ad_image_url(@ad_image), params: { ad_image: { ad_type: @ad_image.ad_type, column: @ad_image.column, page_id: @ad_image.page_number, row: @ad_image.row } }
    assert_redirected_to ad_image_url(@ad_image)
  end

  test "should destroy ad_image" do
    assert_difference('AdImage.count', -1) do
      delete ad_image_url(@ad_image)
    end

    assert_redirected_to ad_images_url
  end
end
