class User < ActiveRecord::Base
    before_save { self.email = email.downcase }

    validates :email, 
        presence: true, 
        length: { minimum: 5, maximum: 250 },
        email: true,
        uniqueness: { case_sensitive: false }
    validates :institution, 
        presence: true, 
        length: { minimum: 2, maximum: 250 }
    validates :password, 
        presence: true, 
        length: { minimum: 5, maximum: 20 }
    validates :role, presence: true, length: { is: 1 }

    has_secure_password
end
