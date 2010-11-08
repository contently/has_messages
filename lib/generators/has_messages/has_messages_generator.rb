class HasMessagesGenerator < Rails::Generators::Base
  include Rails::Generators::Migration

  def self.source_root
    @source_root ||= File.expand_path('../templates', __FILE__)
  end

  # Implement the required interface for Rails::Generators::Migration.
  # taken from http://github.com/rails/rails/blob/master/activerecord/lib/generators/active_record.rb
  def self.next_migration_number(dirname)
    if ActiveRecord::Base.timestamped_migrations
      Time.now.utc.strftime("%Y%m%d%H%M%S")
    else
      "%.3d" % (current_migration_number(dirname) + 1)
    end
  end

  def generate_migration
    migration_template "001_create_messages.rb", "db/migrate/create_messages.rb"
    sleep(1)
    migration_template "002_create_message_recipients.rb", "db/migrate/create_message_recipients.rb"
  end
 
end
