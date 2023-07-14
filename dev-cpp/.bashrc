# Bash configuration for non-login shells

# Don't do anything if not running interactively
[ -z "$PS1" ] && return

# Don't put duplicate lines or lines starting with space in the history.
HISTCONTROL=ignoreboth

# Append to the history file, don't overwrite it
shopt -s histappend

# For setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# Make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# Colors and Prompt
__c='\e[0m'      # clear
__r='\e[38;5;1m' # red
__g='\e[38;5;2m' # green
__b='\e[38;5;4m' # blue
__y='\e[38;5;3m' # yellow
__p='\e[38;5;5m' # purple
__print_prompt() {
    # User/host
    PS1="[$__g\\u@\\h$__c"

    # Location
    PS1="$PS1] $__y\\W$__c"

    # Git Repo
    if [ "$(git rev-parse --is-inside-work-tree 2>/dev/null)" == "true" ]; then
        __branch=""
        PS1="$PS1 $__b($(git branch --show-current 2>/dev/null))$__c"
    fi
    PS1="$PS1\n$ "
}
PROMPT_COMMAND=__print_prompt

# Set some common, convenient aliases
alias ll='ls -l'
alias lg='ll --group-directories-first'
alias la='ls -A'
alias l='ls -CF'

# Load user-defined shell configurations
__config_files=(
    ~/.bash_aliases
    ~/.bash_exports
    ~/.bash_functions
    ~/.bash_completions
)
for __f in ${__config_files[@]} ; do [ -f $__f ] && . $__f ; done
