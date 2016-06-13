define virtualenvwrapper::add_virtualenvwrapper() {
  $path_for_line = $title
  $virtualenvwrapper = find_virtualenvwrapper()
  if ($virtualenvwrapper == false) {
    notify {"virtualenvwrapper not found, skip adding to ${path_for_line}": }
  } else {
    file_line { "add_virtualenvwrapper_to_${path_for_line}": 
      path => "${path_for_line}",
      ensure => present,
      line => "source '$virtualenvwrapper'",
    }
  }
}
