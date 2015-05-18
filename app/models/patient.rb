class Patient < ActiveRecord::Base
    validates :initials, presence: true, length: { minimum: 2 }
    validates :date_of_birth, presence: true, date: true
    validates :screening_number, numericality: { only_integer: true }
    validates :screening_date, presence: true, date: true
end
