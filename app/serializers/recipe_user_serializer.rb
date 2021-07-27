class RecipeUserSerializer < ActiveModel::Serializer
  attributes :id, :username, :password_digest
end
