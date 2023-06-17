class UserMailer < ApplicationMailer
  def account_activation user
    @user = user

    mail to: user.email, subject: t("user_mailer.account_activation.email_subject")
  end
end
