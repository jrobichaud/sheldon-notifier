#!/bin/sh

_sheldon_base_dir=$(dirname "$0")

function _sheldon_notify {
  local command_result=$1
  local command=$2

  if [ -z "$command" ]; then
    return 0
  fi

  case ${TERM_PROGRAM} in
    iTerm.app)
      local terminal_id="com.googlecode.iterm2"
      ;;
    Apple_Terminal)
      local terminal_id="com.apple.Terminal"
      ;;
    vscode)
      local terminal_id="com.microsoft.VSCode"
      ;;
    *)
      return 0
      ;;
  esac

  local focused_app_id=$(osascript -e 'id of application (path to frontmost application as text)')

  if [ ${focused_app_id} = ${terminal_id} ]; then
    return 0
  fi

  if [ ${command_result} -eq 0 ]; then
      terminal-notifier \
      -title "Command Succeeded" \
      -subtitle "$command" \
      -message "" \
      -activate ${terminal_id} \
      -sender ${terminal_id} \
      -contentImage "$_sheldon_base_dir/success.png"
  else
      terminal-notifier \
      -title "Command Failed" \
      -subtitle "$command" \
      -message "Exit code: $1" \
      -activate ${terminal_id} \
      -sender ${terminal_id} \
      -contentImage "$_sheldon_base_dir/error.png"
  fi
}

preexec(){
  export SHELDON_LAST_CMD=$1
}

precmd(){
  _sheldon_notify $? ${SHELDON_LAST_CMD}
}
