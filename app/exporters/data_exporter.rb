class DataExporter

  def self.export(filename)
    if File.exists?(filename)
      print "Bailing: #{filename} already exists\n"
      return
    end

    stream = File.open(filename, "w")
    data = { year: Rails.application.config.swancon_year }
    data[:users] = UserDataExporter.export_all

    stream.write(JSON.dump(data))
    stream.close
  end

end
