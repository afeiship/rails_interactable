class Post < ApplicationRecord
  belongs_to :user
  acts_as_interactable # 这会根据初始化器配置动态添加 like/favorite 等方法
end