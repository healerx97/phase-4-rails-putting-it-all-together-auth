class RecipesController < ApplicationController
    before_action :authorize
    def index
        recipes = Recipe.all
        render json: recipes, status: :created
    end

    def create
        user = User.find(session[:user_id])
        recipe = user.recipes.create!(recipe_params)
        render json: recipe, status: :created
        rescue ActiveRecord::RecordInvalid => e
            return render json: {errors: [error: "Something went wrong"]}, status: :unprocessable_entity
    end

    private

    def recipe_params
        params.permit(:title, :instructions, :minutes_to_complete)
    end


    def authorize
        return render json: {errors: [error: "You are not authorized"]}, status: :unauthorized unless session.include? :user_id
    end
end
