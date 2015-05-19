require 'date'

class Patient < ActiveRecord::Base
    validates :initials, presence: true, length: { minimum: 2 }
    validates :date_of_birth, presence: true, date: true
    validates :screening_number, 
        numericality: { only_integer: true }, uniqueness: true
    validates :screening_date, presence: true, date: true

    after_initialize do
        if self.new_record?
            # only happens for .new
            self.screening_date = Date.today.to_s
        end
    end

end
