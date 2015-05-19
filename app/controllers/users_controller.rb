class UsersController < ApplicationController
    def new
        @user = User.new
    end

    def show
        @user = User.find(params[:id])
    end

    def create
        @user = User.new(user_params)
        if @user.save
            flash[:success] = "Welcome to FERINJECT!"
            log_in @user
            redirect_to @user
        else
            render 'new'
        end
    end

    private
    def user_params
        params.require(:user).permit(:email, :institution, 
                                        :password, :password_confirmation, 
                                        :role)
    end

end
