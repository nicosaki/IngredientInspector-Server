require 'test_helper'

class IngredientsControllerTest < ActionController::TestCase
  # test "the truth" do
  #   assert true
  # end
  test "should receive data hash from upc query" do
    get :ingredients, {upc: "737628064502"}
    assert_response :success
  end

#   test "should receive" do
#     session[:order_id] = order_items(:one).order_id
#     delete :destroy, {id: order_items(:one).id, quantity: 3}
#     assert_response :redirect
#     assert_not_nil assigns(:order_item)
#   end
#
#   test "should update existing order_items" do
#     session[:order_id] = order_items(:one).order_id
#     post :update, {id: order_items(:one).id, quantity: 3}
#     assert_response :redirect
#     assert_not_nil assigns(:order_item)
#   end
#
#   test "should create user" do
#   assert_difference('User.count') do
#     post :create, user: {username: "newuser", email: "a@a", password: "pw"}
#   end
# end
# test "should get new" do
#     get :new, {username: "newuser", email: "a@a", password: "pw"}
#     assert_response :success
#     assert_not_nil assigns(:user)
#   end
end
