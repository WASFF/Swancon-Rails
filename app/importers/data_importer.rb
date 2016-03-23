class DataImporter

  def self.import(filename)
    unless File.exists?(filename)
      print "Bailing: #{filename} doesn't exist\n"
      return
    end

    stream = File.read(filename)
    data = JSON.parse(stream).with_indifferent_access
    print "Parsing data for convention: #{data[:year]}\n"
    UserImporter.import(data[:users])
    print "\n"
  end

end
