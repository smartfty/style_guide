require 'test_helper'

class PlacedAdsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @placed_ad = placed_ads(:one)
  end

  test "should get index" do
    get placed_ads_url
    assert_response :success
  end

  test "should get new" do
    get new_placed_ad_url
    assert_response :success
  end

  test "should create placed_ad" do
    assert_difference('PlacedAd.count') do
      post placed_ads_url, params: { placed_ad: { ad_type: @placed_ad.ad_type, column: @placed_ad.column, page_id: @placed_ad.page_id, row: @placed_ad.row } }
    end

    assert_redirected_to placed_ad_url(PlacedAd.last)
  end

  test "should show placed_ad" do
    get placed_ad_url(@placed_ad)
    assert_response :success
  end

  test "should get edit" do
    get edit_placed_ad_url(@placed_ad)
    assert_response :success
  end

  test "should update placed_ad" do
    patch placed_ad_url(@placed_ad), params: { placed_ad: { ad_type: @placed_ad.ad_type, column: @placed_ad.column, page_id: @placed_ad.page_id, row: @placed_ad.row } }
    assert_redirected_to placed_ad_url(@placed_ad)
  end

  test "should destroy placed_ad" do
    assert_difference('PlacedAd.count', -1) do
      delete placed_ad_url(@placed_ad)
    end

    assert_redirected_to placed_ads_url
  end
end
