class UserMailer < ApplicationMailer
  def account_activation(user)
    @user = user
    mail to: user.email, subject: 'Account activation'
  end

  def password_reset(user)
    @user = user
    mail to: user.email, subject: 'Password reset'
  end

  def create_account(user, password)
    @user = user
    @password = password
    mail to: user.email, subject: 'Password'
  end

  def block_account(user, reason)
    @user = user
    @reason = reason
    mail to: user.email, subject: 'Block user'
  end

  def open_account(user, reason)
    @user = user
    @reason = reason
    mail to: user.email, subject: 'Open user'
  end
end
