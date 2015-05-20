class UserMailer < ActionMailer::Base
    # rails 4.1.8 needs this here
    default from: "noreply@ferinject.com"

    @@verification_address = "vijay.zala@imperial.nhs.uk"
    #@@verification_address = "jcupitt@gmail.com"

    def account_activation(user)
        @user = user

        mail to: @@verification_address,
            subject: "ferinject account activation for #{user.email}"
    end

end
