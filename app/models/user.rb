class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :posts, dependent: :destroy
  has_many :post_comments, dependent: :destroy
  has_many :post_favorites, dependent: :destroy
  has_many :draft_configurations, dependent: :destroy
  has_many :pc_configurations, dependent: :destroy
  attachment :profile_image

  #VALID_PASSWORD_REGEX = /\A[a-zA-Z0-9]+\z/ #半角英数字をセット
  validates :encrypted_password, presence: true,length: {minimum: 6}#,format: {with: VALID_PASSWORD_REGEX}
  validates :name, presence: true
  validates :email, presence: true, uniqueness: true

end
