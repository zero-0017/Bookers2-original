class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :books, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :book_comments, dependent: :destroy

  #チャット/DM機能
  has_many :user_rooms, dependent: :destroy
  has_many :chats, dependent: :destroy
  # has_many :rooms, through: :user_rooms

  #フォローしているユーザー
  has_many :relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  has_many :following, through: :relationships, source: :followed

  #フォローされるユーザー
  has_many :reverse_of_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  has_many :follower, through: :reverse_of_relationships, source: :follower


  has_one_attached :profile_image

  validates :name, length: { minimum: 2, maximum: 20 }, uniqueness: true
  validates :introduction, length: { maximum: 50 }

  def get_profile_image
    (profile_image.attached?) ? profile_image : 'no_image.jpg'
  end

  def is_followed_by?(user)
    reverse_of_relationships.find_by(follower_id: user.id).present?
  end

# 検索方法分岐
  def self.looks(search, word)
    if search == "perfect_match"#・完全一致→perfect_match
      @user = User.where("name LIKE?", "#{word}")
    elsif search == "forward_match"#・前方一致→forward_match
      @user = User.where("name LIKE?","#{word}%")
    elsif search == "backward_match"#・後方一致→backword_match
      @user = User.where("name LIKE?","%#{word}")
    elsif search == "partial_match"#・部分一致→partial_match
      @user = User.where("name LIKE?","%#{word}%")
    else
      @user = User.all
    end
  end
end
