class UsersController < ApplicationController
    before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
    before_action :correct_user_or_admin, only: [:edit, :update]
    before_action :admin_user, only: :destroy

    def new
        @user = User.new
    end

    def show
        @user = User.find(params[:id])
    end

    def index
        @users = User.paginate(page: params[:page])
    end

    def create
        @user = User.new(user_params)
        if @user.save
            if logged_in? && current_user.admin?
                @user.activate
                flash[:success] = "User #{@user.email} added and approved."
                redirect_to users_path
            else
                @user.send_activation_email
                flash[:info] = "Login application submitted, please wait for approval."
                redirect_to root_url
            end
        else
            render 'new'
        end
    end

    def edit
        @user = User.find(params[:id])
    end

    def update
        @user = User.find(params[:id])
        if not current_user.admin? and params[:user][:role] != @user.role
            flash[:danger] = "Only admin users can change user roles."
            render 'edit'
        else
            if @user.update_attributes(user_params)
                flash[:success] = "Profile updated"
                redirect_to @user
            else
                render 'edit'
            end
        end
    end

    def destroy
        User.find(params[:id]).destroy
        flash[:success] = "User deleted"
        redirect_to users_url
    end

    def logged_in_user
        unless logged_in?
            flash[:danger] = "Please log in."
            redirect_to login_url
        end
    end

    def correct_user_or_admin
        @user = User.find(params[:id])
        redirect_to(root_url) unless current_user?(@user) or current_user.admin?
    end

    private
        def user_params
            params.require(:user).permit(:email, :institution, 
                                         :password, :password_confirmation, 
                                         :role)
        end

        def admin_user
            redirect_to(root_url) unless current_user.admin?
        end
 
end
