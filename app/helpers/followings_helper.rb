module FollowingsHelper
  def already_follow_user?(user)
    current_user.followed_users.exists?(user.id)
  end
end
