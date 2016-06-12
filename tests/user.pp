$user = 'vagrant'
virtualenvwrapper::user {"virtualenvwrapper for $user":
  user => $user,
  envs_dir_rel_path => '.virtualenvs',
  envs_dir_full_path => '/tmp/fullpath'
}
