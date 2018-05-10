class User < ApplicationRecord
  include Clearance::User

  has_many :shouts, dependent: :destroy
  validates :username, presence: true, uniqueness: true
  has_many :likes
  has_many :liked_shouts, through: :likes, source: :shout
  
  has_many :followed_user_relationships,
           foreign_key: 'follower_id',
           class_name: 'FollowingRelationship',
           dependent: :destroy  
  has_many :followed_users, through: :followed_user_relationships

  has_many :followers, 
            through: :followed_user_relationships, 
            class_name: 'FollowingRelationship',
            dependent: :destroy
  has_many :follower_relations, foreign_key: :followed_user_id

  def like(shout)
  	liked_shouts << shout
  end

  def unlike(shout)
    liked_shouts.destroy(shout)
  end
  
  def following?(user)
    followed_user_ids.include?(user.id)
  end

  def liked?(shout)
  	liked_shout_ids.include?(shout.id)
  end

  def to_param
    username
  end

  def follow(user)
    followed_users << user
  end

  def unfollow(user)
    followed_users.delete(user)
  end
end
