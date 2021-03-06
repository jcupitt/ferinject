class Patient < ActiveRecord::Base
    validates :initials, presence: true, length: { minimum: 2 }
    validates :date_of_birth, presence: true, date: true
    validates :hospital_identifier, presence: true, length: { minimum: 2 }
    validates :screening_date, presence: true, date: true
    validates :screening_number, 
        numericality: { only_integer: true }, uniqueness: true, 
        allow_blank: true 

    def self.search(term)
        if Rails.env.development?
            query = "initials like ? OR hospital_identifier like ? OR date_of_birth like ? OR screening_date like ?"
        else
            query = "initials ilike ? OR hospital_identifier ilike ? OR cast(date_of_birth as text) ilike ? OR cast(screening_date as text) ilike ?"
        end

        where(query, "%#{term}%", "%#{term}%", "%#{term}%", "%#{term}%")
    end

    # the range we use for screening_number
    @@screening_range = (1001..1045)

    # patient has been randomized?
    def randomized?
        @@screening_range.include? self.screening_number
    end

    def send_randomization_notification_email(user)
        UserMailer.randomization_notification(self, user).deliver
    end

    # assign a screening_number ... pick the first unused one
    def randomize
        n = nil
        @@screening_range.each do |i|
            if not Patient.find_by screening_number: i
                n = i
                break
            end
        end

        if not n
            return false
        end

        update_attribute(:screening_number, n)
        return true
    end

    # patient randomisation table ... generated with
    # irb(main):006:0> ([:a] * 23 + [:b] * 22).shuffle
    # we wire this table into the model because we want to be sure it won't
    # change

    @@randomization_table = [:b, :b, :b, :a, :b, :b, :a, :b, :b, :a, 
                             :b, :a, :a, :a, :a, :a, :a, :a, :a, :a, 
                             :a, :a, :b, :b, :b, :b, :a, :b, :a, :a, 
                             :a, :a, :b, :b, :b, :a, :b, :b, :b, :b, 
                             :b, :a, :a, :b, :a]

    # patient random code table ... generated with
    # require 'securerandom'
    # Array.new(45).map! { |x| SecureRandom.hex(2) }
    
    @@random_table = ["457e", "f407", "d87e", "a766", "8fa8", "99bc", "8eb4",
        "8f6b", "3db7", "a165", "d30c", "6ed5", "7acd", "bba2", "6cc3", "56fd",
        "764e", "59f5", "a693", "8870", "84ec", "2824", "7c76", "7256", "6c53",
        "4b49", "f0f4", "14b2", "6295", "4782", "e818", "f35c", "7657", "7991",
        "3878", "2d31", "53eb", "28ac", "4197", "8cde", "a405", "d762", "82bb",
        "d75c", "cf68"]

    # treatment table, generated with
    # @@screening_range.each do |i|
    #   code = random_table[i - @@screening_range.first]
    #   path = randomization_table[i - @@screening_range.first]
    #   puts "#{code}, #{path == :a ? 'a' : 'b'}, #{path == :a ?  # 'b' : 'a'}"
    # end
    #
    # 457e, b, a
    # f407, b, a
    # d87e, b, a
    # a766, a, b
    # 8fa8, b, a
    # 99bc, b, a
    # 8eb4, a, b
    # 8f6b, b, a
    # 3db7, b, a
    # a165, a, b
    # d30c, b, a
    # 6ed5, a, b
    # 7acd, a, b
    # bba2, a, b
    # 6cc3, a, b
    # 56fd, a, b
    # 764e, a, b
    # 59f5, a, b
    # a693, a, b
    # 8870, a, b
    # 84ec, a, b
    # 2824, a, b
    # 7c76, b, a
    # 7256, b, a
    # 6c53, b, a
    # 4b49, b, a
    # f0f4, a, b
    # 14b2, b, a
    # 6295, a, b
    # 4782, a, b
    # e818, a, b
    # f35c, a, b
    # 7657, b, a
    # 7991, b, a
    # 3878, b, a
    # 2d31, a, b
    # 53eb, b, a
    # 28ac, b, a
    # 4197, b, a
    # 8cde, b, a
    # a405, b, a
    # d762, a, b
    # 82bb, a, b
    # d75c, b, a
    # cf68, a, b

    def get_path
        n = self.screening_number.to_i - @@screening_range.first
        @@randomization_table.fetch(n, "Error")
    end

    def get_treatment_code
        n = self.screening_number.to_i - @@screening_range.first
        @@random_table.fetch(n, "Error")
    end

end
