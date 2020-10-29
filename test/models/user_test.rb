require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "name required" do
    user = User.new
    user.validate
    assert user.errors[:name].present?
  end
end
