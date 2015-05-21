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

    def get_path
        @@randomization_table.fetch(self.screening_number.to_i, :x)
    end

end
