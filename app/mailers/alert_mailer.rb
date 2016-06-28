class AlertMailer < ApplicationMailer

  default from: 'telmo.reinas@gmail.com'

  def sample_email(user)

    @user = user

    mail to: user.email, subject: "Rails Hello Mail"

  end

end
