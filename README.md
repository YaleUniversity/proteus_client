# Bluecat Proteus API client

  Simple ruby API client for Proteus
  Some inspiration drawn from: https://github.com/rjbalest/proteus-ruby-api

## Overview

  This app connects to a Bluecat Proteus server via SOAP API to perform various DNS-related tasks.
  All of the configuration is in config/config.yml that needs to be customized for you particular 
  setup. All you need is the URL, API username/password and the View ID in Proteus. In our case the
  View ID is the id of the default DNS view as that's where everything goes.

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

SYNOPSIS
    proteus [global options] command [command options] [arguments...]

GLOBAL OPTIONS
    -a, --username=arg    - Username to use when connecting to proteus ENV:PROTEUS_USER (default: none)
    -c, --config_file=arg - Location of a config file (overrides environment variables and command line flags) (default: none)
    --help                - Show this message
    -l, --loglevel=arg    - Log level (debug, info, warn, error) (default: warn)
    -p, --password=arg    - Password to use when connecting to proteus ENV:PROTEUS_PASS (default: none)
    -u, --url=arg         - Url to proteus (not including URI to the WSDL) ENV:PROTEUS_URL (default: none)
    -v, --viewid=arg      - Default view id to use when connecting to proteus ENV:PROTEUS_VIEWID (default: none)

COMMANDS
    alias    - Performs actions on alias records
    external - Performs actions on external records
    help     - Shows a list of commands or help for one command
    host     - Performs actions on host records
    id       - Manage Entities by id
    info     - Displays system info
    ip       - Manage IPv4 addresses
    network  - Manage IPv4 Networks
```

### Example config file:

```yaml
bluecat:
  url: 'https://proteus.its.example.com'
  user: 'api_user'
  password: 'xxx'
  default_viewid: 1234567
log:
  level: warn
```

### Authors
  - Tenyo Grozev (tenyo.grozev@yale.edu)
  - Camden Fisher (edward.fisher@yale.edu)

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
