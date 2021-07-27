class SessionsController < ApplicationController
rescue_from ActiveRecord::RecordNotFound, with: :render_not_found
rescue_from ActiveRecord::RecordInvalid, with: :render_invalid
before_action :authorize, only: [:destroy]
    def create
        user = User.find_by(username: params[:username])
        if user&.authenticate(params[:password])
            session[:user_id] = user.id
            render json: user, status: :created
        else
            render json: { errors: [error: ["Invalid username or password"]] }, status: 401
        end
    
    end

    def destroy
        session.delete :user_id
        head :no_content
    end
    private

    def authorize
        render json: { errors: [error: ["You are not authorized"]]}, status: :unauthorized unless session.include? :user_id
    end
    def render_not_found(e)
        return render json: { errors: e.record.errors }, status: 401
    end

    def render_invalid(e)
        return render json: { errors: e.record.errors}, status: 401
    end
    def session_params
        params.permit(:username, :password)
    end
end
