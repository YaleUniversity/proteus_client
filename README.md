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
gem 'proteus', :git => 'git://git.yale.edu/inf-sa/proteus_client.git'
```

or from the command line:

```
git clone git://git.yale.edu/inf-sa/proteus_client.git
cd proteus_client &&  gem build proteus.gemspec
gem install proteus-*.gem

```

## Common options

The proteus command line utility can be configured via files, environment variables or flags.  See `proteus help` for details.

## Usage

### Add:

Add will add a record to Proteus.

#### host (A) record
```
proteus add host myhost.its.yale.internal 172.16.1.99
```

#### alias (CNAME)
```
proteus add alias myalias.its.yale.internal myhost.its.yale.internal
```

#### external record (outside of proteus managed zones)
```
proteus add external foobar.someother.domain.com
```

### Search:

Search will search for a keyword and return a list of items that match that keyword.

#### host (A) record
```
proteus search host keyword
```

#### alias (CNAME)
```
proteus search alias keyword
```

#### external record (outside of proteus managed zones)
```
proteus search external keyword
```

### Show:

Show will show the details for an entity in Proteus.
 
#### by id
```
proteus show id
```

### Delete:

Delete will remove an entity from Proteus.

*Note:* Deletes are programatically limited to specific `Proteus::Types` identified by `ALLOWDELETE`
 
#### by id
```
proteus delete id
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
