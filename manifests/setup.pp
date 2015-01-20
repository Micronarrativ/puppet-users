# == Define: users::setup
#
define users::setup($hash) {
  if(!defined(User[$name])) {
    user { $name :
      ensure               => $hash[$name]['ensure'],
      allowdupe            => $hash[$name]['allowdupe'],
      attribute_membership => $hash[$name]['attribute_membership'],
      attributes           => $hash[$name]['attributes'],
      auth_membership      => $hash[$name]['auth_membership'],
      auths                => $hash[$name]['auths'],
      comment              => $hash[$name]['comment'],
      expiry               => $hash[$name]['expiry'],
      gid                  => $hash[$name]['gid'],
      groups               => $hash[$name]['groups'],
      home                 => $hash[$name]['home'],
      ia_load_module       => $hash[$name]['ia_load_module'],
      key_membership       => $hash[$name]['key_membership'],
      keys                 => $hash[$name]['keys'],
      managehome           => $hash[$name]['managehome'],
      membership           => $hash[$name]['membership'],
      password             => $hash[$name]['password'],
      password_max_age     => $hash[$name]['password_max_age'],
      password_min_age     => $hash[$name]['password_min_age'],
      profile_membership   => $hash[$name]['profile_membership'],
      profiles             => $hash[$name]['profiles'],
      project              => $hash[$name]['project'],
      provider             => $hash[$name]['provider'],
      role_membership      => $hash[$name]['role_membership'],
      roles                => $hash[$name]['roles'],
      shell                => $hash[$name]['shell'],
      system               => $hash[$name]['system'],
      uid                  => $hash[$name]['uid'],
    }

    # Manage SSH authorized keys entries.
    if($hash[$name]['ssh_authorized_keys']) {
      $_sshauthkey = $hash[$name]['ssh_authorized_keys']
      if(is_hash($_sshauthkey)) {
        $_sshkeys = keys($_sshauthkey)
        users::ssh_authorized_keys {
          $_sshkeys:
            hash => $_sshauthkey,
            user => $name,
        }
      } else {
        notify { "user ssh key data for ${name} must be in hash form": }
      }
    }

    # Manage private and public keypairs for a user
    if($hash[$name]['ssh_authentication_keys']) {
      $_ssh_authentication_keys = $hash[$name]['ssh_authentication_keys']
      if (is_hash($_ssh_authentication_keys)) {
        $_sshseckeys = keys($_ssh_authentication_keys)
        users::ssh_authentication_keys { $_sshseckeys:
          user => $name,
          hash => $_ssh_authentication_keys,
        }
      } else {
        notify { "user ssh key data for ${name} must be in hash form": }
      }
    }


  }
}
