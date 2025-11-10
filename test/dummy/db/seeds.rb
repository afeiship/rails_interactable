user1 = User.create!(name: 'Alice', email: 'alice@example.com')
user2 = User.create!(name: 'Bob', email: 'bob@example.com')
post = Post.create!(title: 'My Post', content: 'Content here...', user: user1)

puts "Created #{user1.name}, #{user2.name}, and #{post.title}"