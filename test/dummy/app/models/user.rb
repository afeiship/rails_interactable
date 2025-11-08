class User < ApplicationRecord
  has_many :posts, dependent: :destroy
  # 假设 User 也可能是被互动的目标，或者作为操作者
  # 但如果 User 只是操作者，这里不需要特别声明
end