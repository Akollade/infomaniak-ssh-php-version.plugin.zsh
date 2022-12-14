ispv_load_php_version() {
    # Current php version without patch version
    local php_current_version=$(php -r "echo PHP_VERSION;" | cut -d'.' -f 1,2)

    # Path to the .php-version file
    local php_version_path="$(ispv_find_php_version)"

    # Check if there exists a .php-version file
    if [ -f "$php_version_path" ]; then
        local php_version=$(cat ${php_version_path})
    else
        return
    fi

    # Check if the current php version matches the version in .php-version
    if [ "$php_version" != "$php_current_version" ]; then
        # switch php versions
        echo "Using PHP: $php_version"
        export PATH=/opt/php$php_version/bin:$PATH
    fi
}


# Functions to find .php-version file
ispv_find_php_version() {
  local dir
  dir="$(ispv_find_up '.php-version')"
  if [ -e "${dir}/.php-version" ]; then
    echo "${dir}/.php-version"
  fi
}

ispv_find_up() {
  local path_
  path_="${PWD}"
  while [ "${path_}" != "" ] && [ ! -f "${path_}/${1-}" ]; do
    path_=${path_%/*}
  done
  echo "${path_}"
}

# Marks as function and suppress alias expansion
autoload -U add-zsh-hook

# Add the above function when the present working directory (pwd) changes
add-zsh-hook chpwd ispv_load_php_version

ispv_load_php_version
