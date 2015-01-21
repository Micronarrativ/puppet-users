# == Define: users::ssh_authentication_keys
#
# Define to set the ssh authentication keys for a user
#
# [*parameter*]
#
# * remote: File from a remote location like another module or location on the
#     puppet master server.
# * file: simple file. Content is specified as well.
# * private: Private key, Content can be specified, but doesn't need to.
#     Automatic lookup for a variable following the scheme
#
#       users::<username>_<keyname>
#
# I am terribly sorry that this code is not as easy, but use some time to get
# into it and I hope you will see its beauty.
#
define users::ssh_authentication_keys($user, $hash, $keyname = $title) {

  $username  = $user
  $groupname = $user
  $keytype   = $hash[$keyname]['type']
  case $keytype {
    'remote'  : {
      $filedefaults = {
        source => $hash[$keyname]['source'],
        }
    }
    'file'    : {
      if (has_key($hash[$keyname], 'content')) {
        $filecontent = $hash[$keyname]['content']
      } else {
        $filecontent = hiera("users::${username}_${keyname}", undef)
      }

      $filedefaults = {
        content => $filecontent,
        }
      }
    'private' : {
      if (has_key($hash[$keyname], 'content')) {
        $filecontent = $hash[$keyname]['content']
      } else {
        $filecontent = hiera("users::${username}_${keyname}", undef)
      }

      $filedefaults = {
        content  => $filecontent,
        }
      }
    default: {
      fail("unknown keytype for user '${username}', '${keytype}'")
      }
  }

  File{
    ensure => present,
    owner  => $username,
    group  => $groupname,
    mode   => '0600',
  }
  create_resources(
    file,
    {"/home/${username}/.ssh/${keyname}" => {} },
    $filedefaults)
}
