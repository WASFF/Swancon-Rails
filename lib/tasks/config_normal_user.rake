desc 'Create admin user'

namespace :swancon do
  task :config_user => :environment do
    gotpass = false
    while true
      print "Enter password for \"user\" user (which will have admin privs)\n"
      print "If empty, \"apg\" will be used to generate.\n"
      STDOUT.flush
      password = STDIN.gets.chomp!
      break if gotpass
    
      if (password.empty?)
        password = `apg -M NC -n 1`.chomp!
      end
    
      print "Password will be: '#{password}'\n"
      print "Okay? (y/n)"
      STDOUT.flush
      confirm = STDIN.gets.chomp!
      break if confirm.downcase == 'y'
    end
    
    user = User.where(:username => "user").first
    if (user == nil)
      user = User.new
      user.username = "user"
      user.email = "user@swancon.org"
      user.confirm!
    end
    user.password = password
    user.password_confirmation = password
    user.save
  end
end
