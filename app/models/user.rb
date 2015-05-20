class User < ActiveRecord::Base
    attr_accessor :remember_token, :activation_token
    before_save   :downcase_email
    before_create :create_activation_digest

    validates :email, 
        presence: true, 
        length: { minimum: 5, maximum: 250 },
        email: true,
        uniqueness: { case_sensitive: false, 
            message: "%{value} is already registered." }
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
            message: "%{value} is not a valid role." }

    has_secure_password

    def send_activation_email
        UserMailer.account_activation(self).deliver
    end

    def activate
        update_attribute(:activated, true)
        update_attribute(:activated_at, Time.zone.now)
    end

    def User.digest(string)
        cost = ActiveModel::SecurePassword.min_cost ? 
                    BCrypt::Engine::MIN_COST :
                    BCrypt::Engine.cost
        BCrypt::Password.create(string, cost: cost)
    end

    def User.new_token
        SecureRandom.urlsafe_base64
    end

    # Remembers a user in the database for use in persistent sessions.
    def remember
        self.remember_token = User.new_token
        update_attribute(:remember_digest, User.digest(remember_token))
    end

    # Returns true if the given token matches the digest.
    def authenticated?(attribute, token)
        digest = send("#{attribute}_digest")
        return false if digest.nil?
        BCrypt::Password.new(digest).is_password?(token)
    end

    def admin?
        self.role == "admin"
    end

    def nurse?
        self.role == "nurse"
    end

    def physician?
         role == "physician"
    end

    private

        def downcase_email
            self.email = email.downcase
        end

        def create_activation_digest
            self.activation_token = User.new_token
            self.activation_digest = User.digest(activation_token)
        end

end
