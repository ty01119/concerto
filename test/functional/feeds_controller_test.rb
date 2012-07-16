require 'test_helper'

class FeedsControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  def setup
    request.env["devise.mapping"] = Devise.mappings[:user]
  end

  test "must sign in before new" do
    get :new
    assert_login_failure
  end

  test "not signed in user has nothing to moderate" do
    get :index
    assert assigns(:pending_submissions_count)
    assert_equal assigns(:pending_submissions_count), 0
  end

  test "moderator has pending submissions" do
    sign_in users(:katie)
    get :index
    assert assigns(:pending_submissions_count)
    assert_equal assigns(:pending_submissions_count), 1
  end

  test "moderate index shows pending submissions" do
    sign_in users(:katie)
    get :moderate
    assert assigns(:feeds)
    assert_equal assigns(:feeds), [feeds(:service)]
  end

  test "moderate page not allowed without sign in" do
    get :moderate
    assert_login_failure
  end

end
