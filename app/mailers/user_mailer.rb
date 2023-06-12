class UserMailer < ApplicationMailer
  def retreive_quote(quote)
    @name = quote.user.first_name
    @url = "file:///Users/xavier/yago-challenge-xa/frontend/purchase_process.html?token=#{quote.token}"
    mail(to: quote.user.email, subject: "Your quote from Yago")
  end
end
