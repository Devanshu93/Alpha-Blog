class UserMailer < ApplicationMailer
  default :from => "devanshu.row1993@gmail.com"

  def registration_confirmation(user)
    @user = user
    mail(:to => "#{user.username} <#{user.email}>", :subject => "Registration Confirmation")
  end
end
