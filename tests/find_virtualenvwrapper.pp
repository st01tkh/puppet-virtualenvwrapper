$found = find_virtualenvwrapper()
if ($found == false) {
    notify {"not found": }
} else {
    notify {"found: $found": }
}
