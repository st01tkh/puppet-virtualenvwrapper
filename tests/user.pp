$user = 'user01'
virtualenvwrapper::user {"$user venvs": 
  user => $user,
  envs_dir_rel_path => 'venvs',
}
