# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{has_messages}
  s.version = "0.4.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Aaron Pfeifer"]
  s.date = %q{2011-10-04}
  s.description = %q{Demonstrates a reference implementation for sending messages between users in ActiveRecord}
  s.email = %q{aaron@pluginaweek.org}
  s.files = ["generators/has_messages", "generators/has_messages/has_messages_generator.rb", "generators/has_messages/templates", "generators/has_messages/templates/001_create_messages.rb", "generators/has_messages/templates/002_create_message_recipients.rb", "generators/has_messages/USAGE", "lib/generators", "lib/generators/has_messages", "lib/generators/has_messages/has_messages_generator.rb", "lib/generators/has_messages/templates", "lib/generators/has_messages/templates/001_create_messages.rb", "lib/generators/has_messages/templates/002_create_message_recipients.rb", "lib/generators/has_messages/USAGE", "lib/has_messages", "lib/has_messages/acts_as_message_topic.rb", "lib/has_messages/models", "lib/has_messages/models/message.rb", "lib/has_messages/models/message_recipient.rb", "lib/has_messages.rb", "test/app_root", "test/app_root/app", "test/app_root/app/models", "test/app_root/app/models/topic.rb", "test/app_root/app/models/user.rb", "test/app_root/config", "test/app_root/config/environment.rb", "test/app_root/db", "test/app_root/db/migrate", "test/app_root/db/migrate/001_create_users.rb", "test/app_root/db/migrate/002_migrate_has_messages_to_version_2.rb", "test/factory.rb", "test/functional", "test/functional/has_messages_test.rb", "test/test_helper.rb", "test/unit", "test/unit/message_recipient_test.rb", "test/unit/message_test.rb", "CHANGELOG.rdoc", "init.rb", "LICENSE", "Rakefile", "README.rdoc"]
  s.homepage = %q{http://www.pluginaweek.org}
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{pluginaweek}
  s.rubygems_version = %q{1.6.2}
  s.summary = %q{Demonstrates a reference implementation for sending messages between users in ActiveRecord}
  s.test_files = ["test/functional/has_messages_test.rb", "test/unit/message_recipient_test.rb", "test/unit/message_test.rb"]

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<state_machine>, [">= 0.7.0"])
    else
      s.add_dependency(%q<state_machine>, [">= 0.7.0"])
    end
  else
    s.add_dependency(%q<state_machine>, [">= 0.7.0"])
  end
end
