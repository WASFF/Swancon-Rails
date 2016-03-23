desc 'Reset data for new year'

namespace :swancon do
  task :import_data, [:filename] => :environment do |t, args|
    args.with_defaults(filename: Rails.root.join('condata.json'))
    DataImporter.import(args[:filename])
  end
end
