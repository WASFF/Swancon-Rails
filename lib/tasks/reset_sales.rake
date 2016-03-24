desc 'Reset Sales'

namespace :swancon do
  task :reset_sales => :environment do
    print "WARNING: this will blow away all orders and purchases\n"
    print "Okay? (y/n)"
    STDOUT.flush
    confirm = STDIN.gets.chomp!
    next unless confirm.downcase == 'y'

    models = Payment, UserOrder, VendorOrder, UserOrderTicket,
      UserOrderTicketTransfer, UserOrderMerchandise, UserOrderMerchandiseOption

    config = ActiveRecord::Base.configurations[::Rails.env]
    ActiveRecord::Base.establish_connection

    models.each do |model|
      print "Erasing #{model.to_s}\n"
      case config["adapter"]
        when "mysql", "postgresql"
          ActiveRecord::Base.connection.execute("TRUNCATE #{model.table_name}")
        when "sqlite", "sqlite3"
          ActiveRecord::Base.connection.execute("DELETE FROM #{model.table_name}")
          ActiveRecord::Base.connection.execute("DELETE FROM sqlite_sequence where name='#{model.table_name}'")
          ActiveRecord::Base.connection.execute("VACUUM")
      end
    end
  end
end
