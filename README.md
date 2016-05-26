## Bluecat Proteus API client

  Simple ruby API client for Proteus

### Overview

  This app connects to a Bluecat Proteus server via SOAP API to perform various DNS-related tasks.
  All of the configuration is in config/config.yml that needs to be customized for you particular setup. All you need is basically the URL, API username/password and the View ID in Proteus. In our case the View ID is the id of the default DNS view as that's where everything goes.

### Setup
```
cp -p config/config.yml.example config/config.yml
# edit credentials in config/config.yml
bundle install
```

### Add a host (A) record
```
bundle exec ruby add_host.rb myhost.its.yale.internal 172.16.1.99
```

### Add an alias (CNAME)
```
bundle exec ruby add_alias.rb myalias.its.yale.internal myhost.its.yale.internal
```

### Authors
  - Tenyo Grozev (tenyo.grozev@yale.edu)
