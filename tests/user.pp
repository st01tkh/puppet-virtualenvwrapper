$user = 'user01'
virtualenvwrapper::user {"$user venvs": 
  user => $user,
  use_home_var => true,  
  envs_dir_rel_path => 'venvs',
  proj_dir_rel_path => 'projs',
}

#
# vim: tabstop=2 shiftwidth=2 expandtab
# 
