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

class CreateScheduledWorkVersionsTable < ActiveRecord::Migration
  def self.up
    create_table "scheduled_work_versions", :force => true do |t|
      t.integer  "scheduled_work_id"
      t.integer  "version"
      t.integer  "plan_id"
      t.integer  "stream_id"
      t.integer  "project_id"
      t.integer  "card_id"
      t.string   "name"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    add_column :scheduled_works, :version, :integer
  end

  def self.down
    remove_column :scheduled_works, :version
    drop_table 'scheduled_work_versions'
  end
end
