#!/usr/bin/env bash

# Define version of cube script
VERSION="1.0.0"

# Define colors that are used for console output
ESC_SEQ="\x1b["
COL_RESET=${ESC_SEQ}"39;49;00m"
COL_YELLOW=${ESC_SEQ}"33;01m"
COL_CYAN=${ESC_SEQ}"0;36m"
COL_GREEN=${ESC_SEQ}"0;32m"
COL_MAGENTA=${ESC_SEQ}"0;35m"

# Utility function to print messages to the console
console() {
  if [ -z "$2" ]; then
    echo -e "$1"
  else
    echo -e "${2}${1}${COL_RESET}"
  fi
}

# Determine which OS the script is being run on
UNAMEOUT="$(uname -s)"
case "${UNAMEOUT}" in
Linux*) MACHINE=linux ;;
Darwin*) MACHINE=mac ;;
MINGW64_NT-10.0*) MACHINE=mingw64 ;;
*) MACHINE="UNKNOWN" ;;
esac

# If running on unsupported system - print out error message and exit
if [ "$MACHINE" == "UNKNOWN" ]; then
  console "Unsupported system type\nSystem must be a Mac, Linux or Windows\n" "${COL_YELLOW}"
  console "System detection determined via uname command" "${COL_YELLOW}"
  console "If the following is empty, could not find uname command: $(which uname)" "${COL_YELLOW}"
  console "Your reported uname is: $(uname -s)" ${COL_YELLOW}
  exit 1
fi

# Utility function to show version information
showVersion() {
  console "\n🐳 ${COL_GREEN}Docker CUBE${COL_RESET} ${COL_CYAN}(v${VERSION})${COL_RESET}"
}

# Create base docker-compose command to run
COMPOSE="docker-compose"

# Show version information
if [ "$1" == "--version" ] || [ "$1" == "-v" ]; then
  showVersion
  exit 1
fi

# Spin up containers
if [ "$1" == "start" ]; then
  if [ "$2" == "build" ]; then
    $COMPOSE  up -d --build server || exit 1
    console "🧊 Development environment build and up and running!\n" "${COL_CYAN}"
  else
    $COMPOSE  up -d server || exit 1
    console "🧊 Development environment up and running!\n" "${COL_CYAN}"
  fi
fi

if [ "$1" == "stop" ]; then
  if [ "$EXEC" == "no" ]; then
    console "🧊 Development environment already shut down." "${COL_YELLOW}"
    exit 0
  fi
  $COMPOSE down || exit 1
  console "🧊 Development environment successfully shut down!\n" "${COL_CYAN}"
fi

# Adding composer files
if [ "$1" == "composer" ]; then
  if [ "$2" == "new" ]; then
    $COMPOSE  run --rm composer create-project laravel/laravel . || exit 1
    console "🧊 Adding Composer Files!\n" "${COL_CYAN}"
  fi

  if [ "$2" == "change" ]; then
    chown $USER:$USER $PWD/src || exit 1
    console "🧊 Updating Composer Files!\n" "${COL_CYAN}"
  fi
fi

# Artisan utility container
if [ "$1" == "artisan" ]; then
  if [ "$2" == "migrate" ]; then
    $COMPOSE  run --rm artisan migrate || exit 1
    console "🧊 Migration Done!\n" "${COL_CYAN}"
  fi
fi
