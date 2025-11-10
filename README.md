# RailsInteractable
> Add like/favorite interactions to Rails models.

## Installation

Add this line to your application's Gemfile:

```ruby
gem "rails_interactable"
```

And then execute:
```bash
$ bundle install
```

Or install it yourself as:
```bash
$ gem install rails_interactable
```

## Usage

1.  **Generate Migration and Initializer**: Run the generator to create the necessary database migration and configuration initializer.
    ```sh
    rails generate rails_interactable:install
    ```
    This command creates:
    *   A migration file (`db/migrate/xxx_create_interactions.rb`) for the `interactions` table.
    *   An initializer file (`config/initializers/rails_interactable.rb`) to configure interaction types.

2.  **Run the Migration**: Execute the generated migration to create the `interactions` table in your database.
    ```sh
    rails db:migrate
    ```

3.  **Configure Interaction Types**: Edit `config/initializers/rails_interactable.rb` to define the types of interactions your application supports. You can also define aliases for convenience.
    ```ruby
    # config/initializers/rails_interactable.rb
    RailsInteractable.interaction_types = {
      like: { alias: :liked_by? },
      favorite: { alias: :favorited_by? }
      # Add more types as needed, e.g.:
      # bookmark: { alias: :bookmarked_by? }
    }
    ```

4.  **Make Models Interactable (as Target)**: Add `acts_as_interactable` to the models that can receive interactions (e.g., `Post`, `Video`).
    ```ruby
    # app/models/post.rb
    class Post < ApplicationRecord
      belongs_to :user
      acts_as_interactable # Generates methods like post.likes, post.add_like(user), etc.
    end
    ```

5.  **Make Models an Operator**: Add `acts_as_operator` to the models that perform interactions (e.g., `User`).
    ```ruby
    # app/models/user.rb
    class User < ApplicationRecord
      has_many :posts, dependent: :destroy
      acts_as_operator # Generates methods like user.liked, user.liked_of(Post), user.liked?(post), etc.
    end
    ```

## API

### On Interactable Models (e.g., `Post`)

*   **Check Interaction**: `post.interacted_by_like?(user)` / `post.liked_by?(user)` (if alias configured)
*   **Get Interactors**: `post.likes` (list of users who liked), `post.like_ids` (list of user IDs)
*   **Get Count**: `post.like_count`
*   **Add Interaction**: `post.add_like(user)`
*   **Remove Interaction**: `post.remove_like(user)`
*   **Toggle Interaction**: `post.toggle_like(user)`
*   **Generic Check**: `post.interacted_by?(user, 'like')`
*   **Generic Add/Remove/Toggle**: `post.add_interaction(user, 'like')`, `post.remove_interaction(user, 'like')`, `post.toggle_interaction(user, 'like')`

### On Operator Models (e.g., `User`)

*   **Check Interaction**: `user.liked?(post)` / `user.favorited?(post)`
*   **Get Interacted Targets**: `user.liked` (all liked items), `user.favorited` (all favorited items)
*   **Get Interacted Target IDs**: `user.liked_ids` (IDs of all liked items), `user.favorited_ids` (IDs of all favorited items)
*   **Get Interacted Targets of Specific Type and Model**: `user.liked_of(Post)` (all Posts liked by user), `user.favorited_of(Post)` (all Posts favorited by user)
*   **Get Interacted Target IDs of Specific Type and Model**: `user.liked_ids_of(Post)` (IDs of Posts liked by user), `user.favorited_ids_of(Post)` (IDs of Posts favorited by user)
*   **Get Interaction Records**: `user.like_interactions`, `user.favorite_interactions`

## Resources
- https://chat.qwen.ai/c/4d8b4f97-785b-4aa0-87db-29e7671aa3c5

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).