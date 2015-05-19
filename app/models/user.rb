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
        length: { minimum: 5, maximum: 20 },
        allow_blank: true
    validates :role, 
        presence: true, 
        inclusion: { in: %w(admin nurse physician),
            message: "%{value} is not a valid role" }

    has_secure_password

    def admin?
        self.role == "admin"
    end

    def nurse?
        self.role == "nurse"
    end

    def physician?
         role == "physician"
    end

end
