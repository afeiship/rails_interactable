# lib/generators/rails_interactable/templates/initializer.rb
RailsInteractable.interaction_types = {
  like: { alias: :liked_by? },
  favorite: { alias: :favorited_by? }
  # 可以添加更多类型
  # comment: {},
  # share: { alias: :shared_by? }
}