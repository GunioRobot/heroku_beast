namespace :heroku do
  task :bootstrap, [:site_name, :site_url] => ["db:reset", "db:schema:load", "db:migrate"] do |t, args|
    args.with_defaults(:site_name => "localhost", :site_url => "localhost")
    site = Site.new :name => args.site_name, :host => args.site_url
    begin
      site.save!
    rescue ActiveRecord::RecordInvalid
      puts "The site didn't validate for whatever reason. Fix and call site.save!"
      puts site.errors.full_messages.to_sentence
      debugger
    end
    puts "Site created successfully"
    puts site.inspect
    puts
    user = site.all_users.build :login => 'heroku', :email => 'admin@example.com'
    user.admin = true
    user.password = user.password_confirmation = 'heroku'
    begin
      user.save!
    rescue ActiveRecord::RecordInvalid
      puts "The user didn't validate for whatever reason. Fix and call user.save!"
      puts user.errors.full_messages.to_sentence
      debugger
    end
    user.activate!
    puts "User created successfully"
    puts user.inspect
    puts
  end
end