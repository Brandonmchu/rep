class UserMailer < ActionMailer::Base
  default from: "from@example.com"

  def email_user(user,sales)
  	@user = user
  	@sales = sales
  	@url = 'stark-sierra-3339.herokuapps.com'
  	mail(to: @user.email, subject: "There's a New Sale where You're Interested!")
  end
end
