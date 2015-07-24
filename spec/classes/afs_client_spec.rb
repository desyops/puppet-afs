require 'spec_helper'

describe 'afs::client', :type => :class do
  let(:facts) {{ :operatingsystem => 'Scientific', :osfamily => 'RedHat' }}
    it { is_expected.to contain_anchor('afs::client::begin') }
    it { is_expected.to contain_class('afs::client::install').that_requires('Anchor[afs::client::begin]') }
    it { is_expected.to contain_class('afs::client::config').that_requires('Class[afs::client::install]') }
    it { is_expected.to contain_class('afs::client::service').that_subscribes_to('Class[afs::client::config]') }
    it { is_expected.to contain_anchor('afs::client::end').that_requires('Class[afs::client::service]') }

  describe 'for operating system unsupported' do
    let(:facts) { { :operatingsystem => 'unsupported' } }
    it { expect { is_expected.to compile }.to  raise_error(Puppet::Error, /afs is not supported on unsupported./) }
  end

  describe 'with invalid cache_size' do
    let(:facts) { {:operatingsystem => 'Scientific', :osfamily => 'RedHat' } }
    let(:params) { {:cache_size => 'INVALID' } }
    it { expect { is_expected.to compile }.to raise_error(Puppet::Error, /cache_size is set to 'INVALID', must be 'AUTOMATIC' or a integer size/)}
  end

  context 'afs::client::install' do
    describe "on operatingsystem RedHat" do
      let(:facts) {{ :operatingsystem => 'RedHat', :osfamily => 'RedHat' }}
      it 'is_expected.to install OpenAFS client' do
        is_expected.to contain_package('openafs-client').with({
          'ensure' => 'installed',
          'name'   => 'openafs-client',
        })
        is_expected.to contain_package('openafs-krb5').with({
          'ensure' => 'installed',
          'name'   => 'openafs-krb5',
        })
      end
    end
    describe "on operatingsystem Scientific" do
      let(:facts) {{ :operatingsystem => 'Scientific', :osfamily => 'RedHat' }}
      it 'is_expected.to install OpenAFS client' do
        is_expected.to contain_package('openafs-client').with({
          'ensure' => 'installed',
          'name'   => 'openafs-client',
        })
        is_expected.to contain_package('openafs-krb5').with({
          'ensure' => 'installed',
          'name'   => 'openafs-krb5',
        })
      end
    end
    describe "on operatingsystem Debian/Ubuntu" do
      let(:facts) {{ :operatingsystem => 'Debian',
		     :osfamily => 'Debian',
                     :afs_cache_size => '100000'
      }}
      it 'is_expected.to install OpenAFS client' do
        is_expected.to contain_package('openafs-client').with({
          'ensure' => 'installed',
          'name'   => 'openafs-client',
        })
        is_expected.to contain_package('openafs-krb5').with({
          'ensure' => 'installed',
          'name'   => 'openafs-krb5',
        })
        is_expected.to contain_package('libpam-afs-session').with({
          'ensure' => 'installed',
        })
      end
    end
  end

  context 'afs::client::config' do
    describe 'on operatingsystem Scientific' do
      let(:facts) {{ :operatingsystem => 'Scientific', :osfamily => 'RedHat' }}
      it { is_expected.to contain_file('ThisCell').with({
        'ensure' => 'present',
        'path'   => '/usr/vice/etc/ThisCell',
        'owner'  => 'root',
        'group'  => 'root',
        'mode'   => '0644',
        'content' => /example.org\n/,
      })}
      it { is_expected.to contain_file('afs.conf').with({
        'ensure'  => 'present',
        'path'    => '/etc/sysconfig/afs',
        'owner'   => 'root',
        'group'   => 'root',
        'mode'    => '0755',
      })}
      it { is_expected.to contain_file('afs.conf').with_content(/CACHESIZE=AUTOMATIC/)}
      it { is_expected.to contain_file('afs.conf').with_content(/OPTIONS=" "/)}
      it { is_expected.to contain_file('afs.conf').with_content(/AFSDIR=\/afs/)}
      it { is_expected.to contain_file('afs.conf').with_content(/CACHEDIR=\/var\/cache\/afs/)}
      it { is_expected.to contain_file('afs.conf').with_content(/\/usr\/bin\/fs sysname -newsys amd64_rhel60 amd64_linux26/)}
    end
    describe 'on operatingsystem RedHat' do
      let(:facts) {{ :operatingsystem => 'RedHat', :osfamily => 'RedHat' }}
      it { is_expected.to contain_file('ThisCell').with({
        'ensure' => 'present',
        'path'   => '/usr/vice/etc/ThisCell',
        'owner'  => 'root',
        'group'  => 'root',
        'mode'   => '0644',
        'content' => /example.org\n/,
      })}
      it { is_expected.to contain_file('afs.conf').with({
        'ensure'  => 'present',
        'path'    => '/etc/sysconfig/openafs',
        'owner'   => 'root',
        'group'   => 'root',
        'mode'    => '0755',
      })}
      it { is_expected.to contain_file('afs.conf').with_content(/CACHESIZE=AUTOMATIC/)}
      it { is_expected.to contain_file('afs.conf').with_content(/OPTIONS=" "/)}
      it { is_expected.to contain_file('afs.conf').with_content(/AFSDIR=\/afs/)}
      it { is_expected.to contain_file('afs.conf').with_content(/CACHEDIR=\/var\/cache\/afs/)}
      it { is_expected.to contain_file('afs.conf').with_content(/\/usr\/bin\/fs sysname -newsys amd64_rhel60 amd64_linux26/)}
    end
    describe 'on operatingsystem Debian/Ubuntu' do
      let(:facts) {{ :operatingsystem => 'Debian',
		     :osfamily => 'Debian',
                     :afs_cache_size => '100000'
      }}
      it { is_expected.to contain_file('ThisCell').with({
        'ensure' => 'present',
        'path'   => '/etc/openafs/ThisCell',
        'owner'  => 'root',
        'group'  => 'root',
        'mode'   => '0644',
        'content' => /example.org\n/,
      })}
      it { is_expected.to contain_file('afs.conf').with({
        'ensure'  => 'present',
        'path'    => '/etc/openafs/afs.conf',
        'owner'   => 'root',
        'group'   => 'root',
        'mode'    => '0644',
      })}
      it { is_expected.to contain_file('afs.conf').with_content(/AFS_SYSNAME="amd64_ubu124 amd64_linux26"/)}
      it { is_expected.to contain_file('afs.conf').with_content(/OPTIONS=" "/) }
      it { is_expected.to contain_file('afs.conf.client').with({
        'ensure' => 'present',
        'path'   => '/etc/openafs/afs.conf.client',
        'owner'  => 'root',
        'group'  => 'root',
        'mode'   => '0644',
      })}
      it { is_expected.to contain_file('cacheinfo').with({
        'ensure'  => 'present',
        'path'    => '/etc/openafs/cacheinfo',
        'owner'   => 'root',
        'group'   => 'root',
        'mode'    => '0644',
        'content' => /\/afs:\/var\/cache\/openafs:100000/,
      })}
    end
  end

  context 'afs::client::service' do
    describe "on operatingsystem Scientific" do
      let(:facts) {{ :operatingsystem => 'Scientific', :osfamily => 'RedHat' }}
      it { is_expected.to contain_service('afs').with({
        'ensure'    => 'running',
        'enable'    => true,
        'hasstatus' => true,
        'name'      => 'afs',
      })}
    end
    describe "on operatingsystem RedHat" do
      let(:facts) {{ :operatingsystem => 'RedHat', :osfamily => 'RedHat' }}
      it { is_expected.to contain_service('afs').with({
        'ensure'    => 'running',
        'enable'    => true,
        'hasstatus' => true,
        'name'      => 'afs',
      })}
    end
    describe "on operatingsystem Debian/ubuntu" do
      let(:facts) {{ :operatingsystem => 'Debian', :afs_cache_size => '100000', :osfamily => 'Debian' }}
      it { is_expected.to contain_service('afs').with({
        'ensure'    => 'running',
        'enable'    => true,
        'hasstatus' => false,
        'name'      => 'openafs-client',
      })}
    end
    describe "with disabled service management" do
      let(:params) {{ :manage_service => false }}
      it { is_expected.not_to contain_service('afs') }
    end
  end
end
# vim:ft=ruby
