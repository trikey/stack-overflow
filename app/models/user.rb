class User < ApplicationRecord
  has_many :questions, dependent: :nullify
  has_many :answers, dependent: :nullify
  has_many :authorizations, dependent: :destroy

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, omniauth_providers: [:twitter, :vkontakte]

  def author_of?(object)
    object.user_id == id
  end

  def self.find_for_oauth(auth)
    return nil if (auth.blank? || auth['devise.provider'].blank? || auth['devise.uid'].blank?)

    authorization = Authorization.where(provider: auth['devise.provider'], uid: auth['devise.uid'].to_s).first
    return authorization.user if authorization

    return nil if (auth['devise.email'].blank?)

    user = User.find_or_initialize_by(email: auth['devise.email'])
    authorization = user.authorizations.build(provider: auth['devise.provider'], uid: auth['devise.uid'])

    if user.persisted?
      authorization.save
    else
      user.save! if user.email
    end

    user
  end

  def self.new_with_session(params, session)
    if session['devise.authorization']
      user = find_or_initialize_by(email: params[:email])
      user.authorizations.build(session['devise.authorization'])

      if user.persisted?
        user.update(confirmed_at: nil) && user.send_reconfirmation_instructions
      else
        user.attributes = params
        user.valid?
      end
      user
    else
      super
    end
  end

  def password_required?
    super && authorizations.blank?
  end

  def update_with_password(params, *options)
    if encrypted_password.blank?
      update_attributes(params, *options)
    else
      super
    end
  end
end
