# Bluecat Proteus API client

  Simple ruby API client for Proteus
  Some inspiration drawn from: https://github.com/rjbalest/proteus-ruby-api

## Overview

  This app connects to a Bluecat Proteus server via SOAP API to perform various DNS-related tasks.
  All of the configuration is in config/config.yml that needs to be customized for you particular 
  setup. All you need is the URL, API username/password and the View ID in Proteus. In our case the
  View ID is the id of the default DNS view as that's where everything goes.

## Setup
```
cp -p config/config.yml.example config/config.yml
# edit credentials in config/config.yml
bundle install
```

## Usage

### Add:

Add will add a record to Proteus.

#### host (A) record
```
./proteus add host myhost.its.yale.internal 172.16.1.99
```

#### alias (CNAME)
```
./proteus add alias myalias.its.yale.internal myhost.its.yale.internal
```

#### external record (outside of proteus managed zones)
```
./proteus add external foobar.someother.domain.com
```

### Search:

Search will search for a keyword and return a list of items that match that keyword.

#### host (A) record
```
./proteus search host keyword
```

#### alias (CNAME)
```
./proteus search alias keyword
```

#### external record (outside of proteus managed zones)
```
./proteus search external keyword
```

### Show:

Show will show the details for an entity in Proteus.
 
#### by id
```
./proteus show id
```

### Delete:

Delete will remove an entity from Proteus.

*Note:* Deletes are programatically limited to specific `Proteus::Types` identified by `ALLOWDELETE`
 
#### by id
```
./proteus delete id
```

### Authors
  - Tenyo Grozev (tenyo.grozev@yale.edu)
  - Camden Fisher (edward.fisher@yale.edu)
