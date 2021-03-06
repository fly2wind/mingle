#  Copyright 2020 ThoughtWorks, Inc.
#  
#  This program is free software: you can redistribute it and/or modify
#  it under the terms of the GNU Affero General Public License as
#  published by the Free Software Foundation, either version 3 of the
#  License, or (at your option) any later version.
#  
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU Affero General Public License for more details.
#  
#  You should have received a copy of the GNU Affero General Public License
#  along with this program.  If not, see <https://www.gnu.org/licenses/agpl-3.0.txt>.

# The Plugin::Migrator class contains the logic to run migrations from
# within plugin directories. The directory in which a plugin's migrations
# should be is determined by the Plugin#migration_directory method.
#
# To migrate a plugin, you can simple call the migrate method (Plugin#migrate)
# with the version number that plugin should be at. The plugin's migrations
# will then be used to migrate up (or down) to the given version.
#
# For more information, see Engines::RailsExtensions::Migrations
class Engines::Plugin::Migrator < ActiveRecord::Migrator

  # We need to be able to set the 'current' engine being migrated.
  cattr_accessor :current_plugin

  class << self
    # Runs the migrations from a plugin, up (or down) to the version given
    def migrate_plugin(plugin, version)
      self.current_plugin = plugin
      return if current_version(plugin) == version
      migrate(plugin.migration_directory, version)
    end
    
    def current_version(plugin=current_plugin)
      # Delete migrations that don't match .. to_i will work because the number comes first
      ::ActiveRecord::Base.connection.select_values(
        "SELECT version FROM #{schema_migrations_table_name}"
      ).delete_if{ |v| v.match(/-#{plugin.name}/) == nil }.map(&:to_i).max || 0
    end
  end
       
  def migrated
    sm_table = self.class.schema_migrations_table_name
    ::ActiveRecord::Base.connection.select_values(
      "SELECT version FROM #{sm_table}"
    ).delete_if{ |v| v.match(/-#{current_plugin.name}/) == nil }.map(&:to_i).sort
  end
  
  def record_version_state_after_migrating(version)
    super(version.to_s + "-" + current_plugin.name)
  end
end
