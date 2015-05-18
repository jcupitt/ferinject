class PatientsController < ApplicationController
    def new
    end

    def show
        @patient = Patient.find(params[:id])
    end

    def index
        @patients = Patient.all
    end
 
    def create
        @patient = Patient.new(patient_params)
               
        if @patient.save
            redirect_to @patient
        else
            render 'new'
        end
    end

    private
    def patient_params
        params.require(:patient).permit(:initials, :date_of_birth, 
                                        :screening_number, :screening_date, 
                                        :meets_inclusion_criteria)
    end
end
