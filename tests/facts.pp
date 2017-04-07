#$username = "root"
#$home = "home_$username"
#$home_path = inline_template("<%= scope.lookupvar('::$home') %>")
#
#notify{ "user: $username, homedir: $home_path": }

#$username = "unknown88434"
$username = "vagrant"
$home = "home_$username"
$uid = "user_uid_${username}"

$home_path = inline_template("<%= scope.lookupvar('::$home') %>")
$user_uid = inline_template("<%= scope.lookupvar('::$uid') %>")
if ( $user_uid == "" ) {
  $user_exists = false
} else {
  $user_exists = true
}
#$user_uid = inline_template("<%= scope.lookupvar('user_uid_root') %>")

notify{ "user: $username; homedir: $home_path; uid: $user_uid; exists: $user_exists": }
