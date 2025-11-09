# RailsInteractable
> Add like/favorite interactions to Rails models.

## Usage
1. Use the `rails_interactable` generator to create the migration and model files:
```sh
rails g rails_interactable:install
```
2. User.rb
```ruby
class Post < ApplicationRecord
  belongs_to :user
  acts_as_interactable # 这会根据初始化器配置动态添加 like/favorite 等方法
end

class User < ApplicationRecord
  has_many :posts, dependent: :destroy
  # 假设 User 也可能是被互动的目标，或者作为操作者
  # 但如果 User 只是操作者，这里不需要特别声明
end
```

## Installation
Add this line to your application's Gemfile:

```ruby
gem "rails_interactable"
```

And then execute:
```bash
$ bundle
```

Or install it yourself as:
```bash
$ gem install rails_interactable
```

## Resources
- https://chat.qwen.ai/c/4d8b4f97-785b-4aa0-87db-29e7671aa3c5

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
