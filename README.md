# afs
[![Build Status](https://travis-ci.org/desyops/puppet-afs.png?branch=master)](https://travis-ci.org/desyops/puppet-afs)
## Table of Contents
1. [Overview - What is the AFS module?](#overview)
2. [Module Description - What does the module do?](#module-description)
3. [Setup - The basics of getting started with AFS](#setup)
    * [Beginning with AFS - Installation](#beginning-with-afs)
4. [Usage - The classes and their parameters available for configuration](#usage)
    * [Classes](#classes)
        * [Class: afs](#class-afs)
        * [Class: afs::client](#class-afsclient)
    * [Facts](#facts)
        * [Fact: afs_cache_size](#fact-afs_cache_size)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development](#development)
7. [Contact](#contact)
8. [License](#license)

## Overview ##
The AFS module allows you to manage OpenAFS with Puppet.

## Module Description
OpenAFS is an open source implementation of the Andrew distributed file system (AFS). The afs module allows you to manage OpenAFS packages, configuration and services on Scientific Linux, Ubuntu and Debian.

Currently only a client installation of OpenAFS is supported.

## Setup
**What AFS affects:**

* Configuration files
* Packages, services and configuration for the OpenAFS client
* `/etc/openafs-client/cacheinfo` on Debian and Ubuntu

### Beginning with AFS
To install the OpenAFS client with the default parameters:

```puppet
include afs::client
```

The defaults are determined by your operating system. These are working quite well for Scientific Linux, for Debian and Ubuntu you should consider setting explicit options.

To configure the OpenAFS client, declare the afs::client class:

```puppet
class {'afs::client':
  cell       => 'desy.de',
  cache_dir  => '/var/cache/afs',
  cache_size => '100000',
}
```

Alternatively, you can use Hiera and [Automatic Parameter Lookup](http://docs.puppetlabs.com/hiera/1/puppet.html#automatic-parameter-lookup "Hiera: Automatic Parameter Lookup"):

```yaml
afs::client::cell: 'desy.de'
afs::client::cache_dir: '/var/cache/afs'
afs::client::cache_size: '100000'
```

The above examples will configure the client to use a specific cache directory and size and will belong to the cell *desy.de*.

## Usage
### Classes
#### Class: `afs`
Wrapper class around afs::client, it only declars the `afs::client` class.

#### Class: `afs::client`

The AFS module's primary class for managing the OpenAFS client.

**Parameters within `afs::client`:**

##### `cell`
AFS cell the client should belong to. Defaults to 'example.org'

##### `afs_mount_point`
Mountpoint for AFS. Defaults to '/afs'

##### `cache_dir`
Cache directory for the AFS client. Should be a dedicated partition. Defaults to '/var/cache/afs' for Scientific Linux and '/var/cache/openafs' for Debian/Ubuntu.

##### `cache_size`
Cache size for the AFS client. Should be 85% of `client_cache_dir`, if used on a dedicated partition. Defaults to 'AUTOMATIC' for Scientific Linux, the init value determines the actual cache size and sets the appropiate value.

For Debian/Ubuntu, this defaults to `$::afs_cache_size` fact.

##### `sysname`
Configure the AFS sysname for @sys variable in AFS pathnames. Supports an array of sysname.

##### `config_path`
The configuration path for the client configuration files. Defaults to '/usr/vice/etc' for Scientific Linux and '/etc/openafs-client' for Debian/Ubuntu.

##### `package_name`
Name of the client OpenAFS client package. Defaults to 'openafs-client' for Scientifc Linux and Debian/Ubuntu.

##### `krb5_package_name`
Name of the KRB5 package. Defaults to 'openafs-krb5' for Scientific Linux and Debian/Ubuntu. On Debian/Ubuntu installes additionally 'libpam-afs-session' for PAM support.

##### `service_name`
Service name for the OpenAFS client daemon. Defaults to 'afs' for Scientific Linux and 'openafs-client' for Debian/Ubuntu.

##### `service_status`
Service status available for the OpenAFS client daemon. Defaults to 'true' for Scientific Linux and 'false' for Debian/Ubuntu.

### Facts
#### Fact: `afs_cache_size`
This fact calculates the default AFS cache size for the Debian osfamily.

The fact assumes a dedicated cache partition mounted at `/var/cache/openafs`.
If it is not found, it will fall back to a cache size of 100 MB.
If the dedicated partition is found, it will return 70% of the available 1K blocks.

This behaviour is inspired by the OpenAFS client init script and a cachesize value of `AUTOMATIC`, which is used on Scientific Linux.

## Limitations
This has been tested on Scientific Linux 6, Ubuntu 12.04 and Debian 7. Currently, only a client installation of OpenAFS is supported.

The `afs_cache_size` fact uses a hard coded partition, which is `/var/cache/openafs`. The fact does not work, if it is used with the `afs::client::cache_dir` parameter.

## Development
Please create issues and pull-requests at our project site [puppet-afs](https://github.com/desyops/puppet-afs).

## Contact
DESY IT Puppet Administrators - it-puppet-admin@desy.de

## Copyright and License
Copyright (C) 2014 [Deutsches Elektronen-Synchrotron DESY](https://www.desy.de/)

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

  http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
