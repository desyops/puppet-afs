require 'spec_helper'

describe 'afs::client', :type => :class do
  let(:facts) {{ :operatingsystem => 'Scientific' }}
    it { should contain_anchor('afs::client::begin') }
    it { should contain_class('afs::client::install').that_requires('Anchor[afs::client::begin]') }
    it { should contain_class('afs::client::config').that_requires('Class[afs::client::install]') }
    it { should contain_class('afs::client::service').that_subscribes_to('Class[afs::client::config]') }
    it { should contain_anchor('afs::client::end').that_requires('Class[afs::client::service]') }

  describe 'for operating system unsupported' do
    let(:facts) { { :operatingsystem => 'unsupported' } }
    it { expect { should compile }.to  raise_error(Puppet::Error, /afs is not supported on unsupported./) }
  end

  describe 'with invalid cache_size' do
    let(:facts) { {:operatingsystem => 'Scientific' } }
    let(:params) { {:cache_size => 'INVALID' } }
    it { expect { should compile }.to raise_error(Puppet::Error, /cache_size is set to 'INVALID', must be 'AUTOMATIC' or a integer size/)}
  end

  context 'afs::client::install' do
    describe "on operatingsystem Scientific" do
      let(:facts) {{ :operatingsystem => 'Scientific', :osfamily => 'RedHat' }}
      it 'should install OpenAFS client' do
        should contain_package('openafs-client').with({
          'ensure' => 'installed',
          'name'   => 'openafs-client',
        })
        should contain_package('openafs-krb5').with({
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
      it 'should install OpenAFS client' do
        should contain_package('openafs-client').with({
          'ensure' => 'installed',
          'name'   => 'openafs-client',
        })
        should contain_package('openafs-krb5').with({
          'ensure' => 'installed',
          'name'   => 'openafs-krb5',
        })
        should contain_package('libpam-afs-session').with({
          'ensure' => 'installed',
        })
      end
    end
  end

  context 'afs::client::config' do
    describe 'on operatingsystem Scientific' do
      let(:facts) {{ :operatingsystem => 'Scientific', :osfamily => 'RedHat' }}
      it { should contain_file('ThisCell').with({
        'ensure' => 'present',
        'path'   => '/usr/vice/etc/ThisCell',
        'owner'  => 'root',
        'group'  => 'root',
        'mode'   => '0644',
        'content' => /example.org\n/,
      })}
      it { should contain_file('afs.conf').with({
        'ensure'  => 'present',
        'path'    => '/etc/sysconfig/afs',
        'owner'   => 'root',
        'group'   => 'root',
        'mode'    => '0755',
      })}
      it { should contain_file('afs.conf').with_content(/CACHESIZE=AUTOMATIC/)}
      it { should contain_file('afs.conf').with_content(/OPTIONS=" "/)}
      it { should contain_file('afs.conf').with_content(/AFSDIR=\/afs/)}
      it { should contain_file('afs.conf').with_content(/CACHEDIR=\/var\/cache\/afs/)}
      it { should contain_file('afs.conf').with_content(/\/usr\/bin\/fs sysname -newsys amd64_rhel60 amd64_linux26/)}
    end
    describe 'on operatingsystem Debian/Ubuntu' do
      let(:facts) {{ :operatingsystem => 'Debian',
		     :osfamily => 'Debian',
                     :afs_cache_size => '100000'
      }}
      it { should contain_file('ThisCell').with({
        'ensure' => 'present',
        'path'   => '/etc/openafs/ThisCell',
        'owner'  => 'root',
        'group'  => 'root',
        'mode'   => '0644',
        'content' => /example.org\n/,
      })}
      it { should contain_file('afs.conf').with({
        'ensure'  => 'present',
        'path'    => '/etc/openafs/afs.conf',
        'owner'   => 'root',
        'group'   => 'root',
        'mode'    => '0644',
      })}
      it { should contain_file('afs.conf').with_content(/AFS_SYSNAME="amd64_ubu124 amd64_linux26"/)}
      it { should contain_file('afs.conf').with_content(/OPTIONS=" "/) }
      it { should contain_file('afs.conf.client').with({
        'ensure' => 'present',
        'path'   => '/etc/openafs/afs.conf.client',
        'owner'  => 'root',
        'group'  => 'root',
        'mode'   => '0644',
      })}
      it { should contain_file('cacheinfo').with({
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
      let(:facts) {{ :operatingsystem => 'Scientific' }}
      it { should contain_service('afs').with({
        'ensure'    => 'running',
        'enable'    => true,
        'hasstatus' => true,
        'name'      => 'afs',
      })}
    end
    describe "on operatingsystem Debian/ubuntu" do
      let(:facts) {{ :operatingsystem => 'Debian', :afs_cache_size => '100000' }}
      it { should contain_service('afs').with({
        'ensure'    => 'running',
        'enable'    => true,
        'hasstatus' => false,
        'name'      => 'openafs-client',
      })}
    end
    describe "with disabled service management" do
      let(:params) {{ :manage_service => false }}
      it { should_not contain_service('afs') }
    end
  end
end
# vim:ft=ruby
