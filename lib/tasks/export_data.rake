desc 'Reset data for new year'

namespace :swancon do
  task :export_data, [:filename] => :environment do |t, args|
    args.with_defaults(filename: Rails.root.join('condata.json'))
    DataExporter.export(args[:filename])
  end
end
