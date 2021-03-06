require 'facter'
Facter.add(:dashboard_db_timestamp) do
  install_dir = Facter.value('dashboard_install_dir')
  setcode do
    unless install_dir.nil?
      Facter.value('dashboard_version') =~ /^\d*\.\d*\.\d*/
      version = $~.to_s
      if Gem::Version.new(version) > Gem::Version.new('1.2.23')
        rake_command = 'bundle exec rake'
      else
        rake_command = 'rake'
      end
      db_timestamp = Facter::Util::Resolution.exec("#{rake_command} -f #{install_dir}/Rakefile RAILS_ENV=production db:version 2> /dev/null|tail -1")
      unless db_timestamp.nil?
        db_timestamp.match(/^Current version: (\d*)$/)[1]
      else
        nil
      end
    else
      nil
    end
  end
end