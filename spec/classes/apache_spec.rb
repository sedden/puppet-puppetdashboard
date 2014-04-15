require 'spec_helper'
describe 'puppetdashboard::site::apache', :type => :class do
  context "on a Debian OS" do
    let :facts do
      {
        :osfamily               => 'Debian',
        :operatingsystemrelease => '6',
        :concat_basedir         => '/dne',
        :fqdn                   => 'test.example.org',
      }
    end
    describe 'with default apache and recommended mod_passenger' do
      let :pre_condition do 
        "class { 'apache': }\nclass { 'apache::mod::passenger': passenger_high_performance => 'on', passenger_max_pool_size => 12, passenger_pool_idle_time => 1500, passenger_stat_throttle_rate => 120, rack_autodetect => 'off', rails_autodetect => 'off',}"
      end
      describe "with no parameters" do
        it { should contain_class('puppetdashboard::params') }
        it { should contain_apache__vhost('puppet-dashboard').with(
          'servername'      => 'test.example.org',
          'port'            => '80',
          'docroot'         => '/usr/share/puppet-dashboard/public',
          'error_log_file'  => 'dashboard.test.example.org_error.log'
        )}
      end
      describe "when not given default parameters" do
        let :params do
          {
            :servername     => 'test.example.com',
            :port           => '8080',
            :docroot        => '/opt/puppetdashboard/public',
            :error_log_file => 'dashboard_error.log'
          }
        end
        it { should contain_apache__vhost('puppet-dashboard').with(
          'servername'      => 'test.example.com',
          'port'            => '8080',
          'docroot'         => '/opt/puppetdashboard/public',
          'error_log_file'  => 'dashboard_error.log'
        )}
      end
    end
  end
  context "on a RedHat OS" do
    let :facts do
      {
        :osfamily               => 'RedHat',
        :operatingsystemrelease => '6',
        :concat_basedir         => '/dne',
        :fqdn                   => 'test.example.org',
      }
    end
    it do
      expect {
        should contain_class('puppetdashboard::params')
      }.to raise_error(Puppet::Error, /The NeSI Puppet Dashboard Puppet module does not support RedHat family of operating systems/)
    end
  end
  context "on an Unknown OS" do
    let :facts do
      {
        :osfamily   => 'Unknown',
      }
    end
    it do
      expect {
        should contain_class('puppet::params')
      }.to raise_error(Puppet::Error, /The NeSI Puppet Dashboard Puppet module does not support Unknown family of operating systems/)
    end
  end
end