# Bluecat Proteus API client

  Simple ruby API client for Proteus
  Some inspiration drawn from: https://github.com/rjbalest/proteus-ruby-api

## Overview

  This app connects to a Bluecat Proteus server via SOAP API to perform various DNS-related tasks.
  All of the configuration is in config/config.yml that needs to be customized for you particular 
  setup. All you need is the URL, API username/password and the View ID in Proteus. In our case the
  View ID is the id of the default DNS view as that's where everything goes.  The application also 
  supports configuration via the environment or with command line flags.

## Installation

Add the following to your `Gemfile`

```
gem 'proteus', git: 'https://github.com/YaleUniversity/proteus_client.git'
```

or from the command line:

```
git clone git@github.com:YaleUniversity/proteus_client.git
cd proteus_client &&  gem build proteus.gemspec
gem install proteus-*.gem

```

## Common options

The proteus command line utility can be configured via files, environment variables or flags.  See `proteus help` for details.

## Usage
```
NAME
    proteus - #AllyourDNSRecords are belong to us.

USAGE
    proteus [command, command, ...] [options] [arguments]

DESCRIPTION
    Provides access to proteus DNS and IP management through a CLI.

COMMANDS
    alias        manage external host dns records
    external     manage external host dns records
    help         show help
    host         manage host dns records
    id           manage proteus entities by id
    info         displays proteus system information
    ip           manage ip address records

OPTIONS
       --config_file=<value>      Location of a config (override env/flags)
    -h --help                     show help for this command
       --loglevel=<value>         Log level (debug|info|warn|error)
       --password=<value>         Proteus password ENV:PROTEUS_PASS
       --url=<value>              Proteus URL ENV:PROTEUS_URL
       --username=<value>         Proteus username ENV:PROTEUS_USER
       --viewid=<value>           Default view id ENV:PROTEUS_VIEWID
```

additional help is available from the subcommands.  For example:

```
NAME
    ip - manage ip address records

USAGE
    proteus ip [options]

SUBCOMMANDS
    assign     assign the next available ip by cidr
    delete     delete an ip assignment
    next       show the next available ip by cidr
    show       show an ip assignment
    udf        list user defined fields for ip addresses

OPTIONS
    -c --configid=<value>         Override config id, default gets the first
                                  entity in the view

OPTIONS FOR PROTEUS
       --config_file=<value>      Location of a config (override env/flags)
    -h --help                     show help for this command
       --loglevel=<value>         Log level (debug|info|warn|error)
       --password=<value>         Proteus password ENV:PROTEUS_PASS
       --url=<value>              Proteus URL ENV:PROTEUS_URL
       --username=<value>         Proteus username ENV:PROTEUS_USER
       --viewid=<value>           Default view id ENV:PROTEUS_VIEWID
```

```
NAME
    assign - assign the next available ip by cidr

USAGE
    proteus ip assign [options] cidr fqdn
    [properties]

DESCRIPTION
    Assigns the next available IP address by CIDR.  Behind the scenes, this
    is generating a "canary" ip address which is used to get the network ID
    which is used as the parent for assignment. Properties are currently
    passed as a string of key=value pairs separated by "|".  ie.
    "foo=bar|baz=buz|boz=biz"

OPTIONS FOR IP
    -c --configid=<value>         Override config id, default gets the first
                                  entity in the view
       --config_file=<value>      Location of a config (override env/flags)
    -h --help                     show help for this command
       --loglevel=<value>         Log level (debug|info|warn|error)
       --password=<value>         Proteus password ENV:PROTEUS_PASS
       --url=<value>              Proteus URL ENV:PROTEUS_URL
       --username=<value>         Proteus username ENV:PROTEUS_USER
       --viewid=<value>           Default view id ENV:PROTEUS_VIEWID
```

### Example config file:

```yaml
url: 'https://proteus.example.com'
username: 'api_user'
password: 'xxx'
viewid: '123456'
log_level: warn
```

### Authors
  - Camden Fisher (camden.fisher@yale.edu)
  - Tenyo Grozev (tenyo.grozev@yale.edu)

### License
```
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```
