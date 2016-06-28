# Preview all emails at http://localhost:3000/rails/mailers/alert_mailer
class AlertMailerPreview < ActionMailer::Preview

  def sample_email_preview
    ExampleMailer.sample_email(User.first)
  end

end
