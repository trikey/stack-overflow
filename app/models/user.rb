class User < ApplicationRecord
  has_many :questions, dependent: :nullify
  has_many :answers, dependent: :nullify

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  def author_of?(object)
    object.user_id == self.id
  end
end
