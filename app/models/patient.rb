class Patient < ActiveRecord::Base
    validates :initials, presence: true, length: { minimum: 2 }
    validates :date_of_birth, presence: true, date: true
    validates :hospital_identifier, presence: true, length: { minimum: 2 }
    validates :screening_date, presence: true, date: true
    validates :screening_number, 
        numericality: { only_integer: true }, uniqueness: true, 
        allow_blank: true 

    # patient has been randomized?
    def randomized?
        (1..45).include? self.screening_number.to_i
    end

    # assign a screening_number ... pick the first unused one
    def randomize
        n = nil
        (1..45).each do |i|
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

    def get_path
        @@randomization_table.fetch(self.screening_number.to_i, "Error")
    end

    def get_treatment_code
        @@random_table.fetch(self.screening_number.to_i, "Error")
    end


end
