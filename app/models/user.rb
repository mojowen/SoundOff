class User < ActiveRecord::Base

  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable,
         :token_authenticatable

  attr_accessible :email, :password, :password_confirmation, :remember_me,
    :name, :phone, :partner

  belongs_to :partner
end
