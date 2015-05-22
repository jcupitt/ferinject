class UserMailer < ActionMailer::Base
    # rails 4.1.8 needs this here
    default from: "noreply@ferinject.com"

    if Rails.env.development?
        @@verification_address = "jcupitt@gmail.com"
    else
        @@verification_address = "vijay.zala@imperial.nhs.uk"
    end

    def account_activation(user)
        @user = user

        mail to: @@verification_address,
            subject: "cosmofer account activation for #{user.email}"
    end

    def randomization_notification(patient, user)
        @patient = patient
        @user = user

        mail to: @@verification_address,
            subject: "cosmofer patient randomization by #{user.email}"
    end

end
