require 'facter'
Facter.add(:dashboard_install_dir) do
  setcode do
    if File.file?('/etc/default/puppet-dashboard-workers')
      dashboard_default = File.open('/etc/default/puppet-dashboard-workers').read()
      dashboard_default.match(/^DASHBOARD_HOME=(.*)$/)[1]
    else
      nil
    end
  end
end