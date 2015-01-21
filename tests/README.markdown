users
====

Overview
--------

The users module allows management of user accounts through hiera or a
hash of directly specified users.

This is a further developed version based on https://forge.puppetlabs.com/mthibaut/users version 1.0.11 from 2013.

Module Description
-------------------

Normally each user needs to be specified inside a puppet manifest. This module
allows you to specify the users outside of puppet, so that the user setup can
become variable.

Setup
-----

### Configure your users in hiera

        common.yaml:

        ---
        users_sysadmins:
          john:
            ensure: present
            uid: 1000
            gid: staff
            groups: - wheel
            comment: John Doe
            managehome: true
            ssh_authorized_keys:
              mykey:
                type: 'ssh-rsa'
                key:  'mykeydata=='
              ssh_keys:
                mysshkey1:
                type  : file
                path  : 'puppet:///keys/mysshkey'
            ssh_authorization_keys:
              mysshkey1.pub
                type  : file
                path  : 'puppet:///keys/mysshkey.pub'
              mysshkey2:
                type  : private

All parameters to the standard types 'user' and 'ssh_authorized_key' can be used.

The type 'private' in for the ssh authorization keys will search for a variable
in hiera following the naming scheme: users::<username>_<keyname>
This must be available in the hiera structure.

    common.yaml

    ---
    users::john_mysshkey1: |
      -----BEGIN RSA PRIVATE KEY-----
      MIICWwIBAAKBgQDIM7iGP3oCCjlUv7URwy1xbVGz7V5nKDxfgIzc0+lUQn+xKPhe
      lMIJyy6pnkA/5fTIE7Qtvt45gCPh+Gziamp428AMXl+2xSJgEQHrBQK4Bj56j+O7
      ZWnbqFIeE9i9BXGP0lqxwO1xTDhZVgSDW9bsyP7J/r2fOZEvybnGqZuitQIBIwKB
      gQC8ww0Q3MN+RCdtKcf6zfeldbNvIaImv4lhW/KHEPHwW/S8+r5KjEHr+hYNo9Yt
      nk0xrC2KN55TeNFgB3ya9p7lUCkK8u16zlJ1KreHrBMNqrZX7+6wQh6u+WgG+n9O
      zVIiRcI6U/7P2gq58JqGougN8ItorXxTEAIoRy2zupgITwJBAORDmbCyrs0BFXtE
      oV1NPwNhA24B4ZWv/+AIO4DsE61kwhrkpeeEpVyc/P1MO0Uxy0OeM+8nHNl4jiSO
      b3UD86MCQQDghziFPMuJ6N3VCiZdz89dUl+vC3v2NHeJdrRidSc4d6GcBSNRxyXK
      SiqIFGP1gHeVxPh+YDnLPSGXvM7jDbXHAkBUyKbMmiOrOuq4wbhHOfLVXow+zX+s
      oHT7cMWk6fiuHhw13+XZpkwMdNL+/w6zTQJa8Z5C4qRQxmCufgwkJgoJAkB54wFs
      5n0e+sGQ6EC2lWHw1PIdMh642qdKn4Z+l15vHF8LjcK3XXrqKEL5aieih5Ff7pWG
      bsBJwhmM4ta1xZ0xAkEAlQ0tgHjPahpnmj17TqqSdwZZNQ0K4Napavo+xFty1Nhz
      UlberiiynrGE/OX5gObHfdnrSfLL82ZRth6bxhup8g== Puppet controlled
      -----END RSA PRIVATE KEY-----


### Include users in your manifest

        site.pp:

        node /default/ {
            users { sysadmins: }
        }

Usage
------

The name given to the users type will be used to lookup 'users_$name' inside
hiera. Alternatively you can specify the hash directly without hiera, see
below.

The defined type *users* can be called with two arguments:

###`match`

Defaults to 'all'. Can be 'all', 'any' (sysonym for 'all'), or 'first'.

If 'first' is used, then only the first match in your hiera hierarchy will be
used. If you specify 'all' then all matching hashes will be be used. This
corresponds directly to the respective 'hiera' and 'hiera_hash' function calls.

###`hash`

Defaults to undef. Uses the given hash rather than the result of the hiera
lookup.

Troubleshooting
---------------

Before blaming me, check if your hiera configuration is working correctly.
For instance, you can use this to check if puppet is seeing your hiera data
correctly:

        node /mynode/ {
                $mytest = hiera("users_sysadmins", "not found")
                notify { "$mytest": }
        }


Dependencies
------------

* In puppet 3.0.0, hiera became a standard function call so it is included by
  default in your puppet installation. Before 3.0.0, you must install the
  hiera-puppet module.

* stdlib
