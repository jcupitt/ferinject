class PatientsController < ApplicationController
    before_action :logged_in_user, only: [:new, :create, :index, :edit, :update, :destroy]
    before_action :admin_user, only: :destroy
    before_action :physician_user, only: [:new, :create, :edit, :update]

    def new
        @patient = Patient.new
    end

    def show
        @patient = Patient.find(params[:id])
    end

    def index
        @patients = Patient.paginate(page: params[:page])
    end

    def edit
        @patient = Patient.find(params[:id])
    end

    def create
        @patient = Patient.new(patient_params)

        if @patient.save
            redirect_to @patient
        else
            render 'new'
        end
    end

    def update
        @patient = Patient.find(params[:id])

        if @patient.update(patient_params)
            redirect_to @patient
        else
            render 'edit'
        end
    end

    def destroy
        @patient = Patient.find(params[:id])
        @patient.destroy
                     
        redirect_to patients_path
    end

    def logged_in_user
        unless logged_in?
            flash[:danger] = "Please log in."
            redirect_to login_url
        end
    end

    private
        def patient_params
            params.require(:patient).permit(:initials, :date_of_birth, 
                                            :screening_number, :screening_date, 
                                            :meets_inclusion_criteria)
        end

        def admin_user
            redirect_to(root_url) unless current_user.admin?
        end

        def nurse_user
            redirect_to(root_url) unless current_user.nurse?
        end
 
        def physician_user
            redirect_to(root_url) unless current_user.physician?
        end
 
end
