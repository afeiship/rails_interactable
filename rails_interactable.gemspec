# frozen_string_literal: true

require_relative "lib/rails_interactable/version"

Gem::Specification.new do |spec|
  spec.name        = "rails_interactable"
  spec.version     = RailsInteractable::VERSION
  spec.authors     = [ "aric.zheng" ]
  spec.email       = [ "1290657123@qq.com" ]
  spec.homepage    = "https://github.com/afeiship/rails_interactable"
  spec.summary     = "Add like/favorite interactions to Rails models."
  spec.description = "A Rails gem for adding like, favorite, and other interaction features to models via dynamic method generation."
  spec.license     = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the "allowed_push_host"
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  # spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"
  # 如果你打算发布到 RubyGems.org，可以删除或注释掉上面这行。
  # 如果只发布到私有服务器，取消注释并设置正确的 URL。

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/afeiship/rails_interactable"
  spec.metadata["changelog_uri"] = "https://github.com/afeiship/rails_interactable/blob/main/CHANGELOG.md"

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  end

  spec.add_dependency "rails", ">= 8.1.1"
end