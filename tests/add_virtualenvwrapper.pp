$user = 'talex_id'
$bashrc = "/tmp/$user/.bashrc"
virtualenvwrapper::add_virtualenvwrapper{"${bashrc}": }
