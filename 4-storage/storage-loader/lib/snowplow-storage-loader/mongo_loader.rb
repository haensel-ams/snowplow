# Copyright (c) 2013 Snowplow Analytics Ltd. All rights reserved.
#
# This program is licensed to you under the Apache License Version 2.0,
# and you may not use this file except in compliance with the Apache License Version 2.0.
# You may obtain a copy of the Apache License Version 2.0 at http://www.apache.org/licenses/LICENSE-2.0.
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the Apache License Version 2.0 is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the Apache License Version 2.0 for the specific language governing permissions and limitations there under.

# Author::    Alex Dean (mailto:support@snowplowanalytics.com)
# CoAuthor::    RDI 
# Copyright:: Copyright (c) 2013 Snowplow Analytics Ltd
# License::   Apache License Version 2.0

# Ruby module to support the load of Snowplow events into mongoDB.
module Snowplow
  module StorageLoader
    module MongoDBLoader

      # Constants for the load process
      EVENT_FILES = "part-*"
      EVENT_FIELD_SEPARATOR = "	"
      NULL_STRING = ""
      QUOTE_CHAR = "\\x01"
      ESCAPE_CHAR = "\\x02"

      # Loads the Snowplow event files into MongoDB.
      #
      # Parameters:
      # +events_dir+:: the directory holding the event files to load 
      # +target+:: the configuration options for this target
      # +skip_steps+:: Array of steps to skip
      # +skip_steps+:: Array of steps to skip			  # not supported at the moment (20141021)
      # +include_steps+:: Array of optional steps to include   	  # not supported at the moment (20141021)
      def load_events(events_dir, target, skip_steps, include_steps)
        puts "Loading Snowplow events into #{target[:name]} (Mongo database)... from event_dir=#{events_dir}"
        event_files = get_event_files(events_dir)
        puts "event_files=#{event_files}"
        for entry in event_files
            puts "Loading the file #{entry}"
            `mongoimport --host #{target[:mongo_host]} --db #{target[:mongo_db]} --collection #{target[:mongo_collection]} --type tsv --file "#{entry}" --fieldFile "/snowplow/4-storage/mongo-storage/atomic_events_header.csv"`
        end
 
      end
      module_function :load_events

      # Get the list of event files.
      #
      # Parameters:
      # +events_dir+:: the directory holding the event files to load 
      #
      # Returns the array of file names.
      def get_event_files(events_dir)
        Dir[File.join(events_dir, '**', EVENT_FILES)].select { |f|
          File.file?(f) # In case of a dir ending in .tsv
        }
      end
      module_function :get_event_files

    end
  end
end
