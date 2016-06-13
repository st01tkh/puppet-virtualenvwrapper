$user = 'talex_id'
virtualenvwrapper::user {"$user": 
  envs_dir_rel_path => 'venvs',
}
