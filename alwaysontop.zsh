function alwaysontop_zcurses_init {
    zmodload zsh/curses
    zcurses init
    zcurses addwin aotwin $(tput lines) $(tput cols) 0 0
    zcurses end
}

function alwaysontop_gototop {
    zcurses init
    zcurses move aotwin 0 0
    zcurses end
}

function alwaysontop_alwaysontop {
    if [[ "$ALWAYSONTOP" != "TRUE" ]]
    then
        export ALWAYSONTOP="TRUE"

        add-zsh-hook precmd alwaysontop_gototop
    fi
}

function alwaysontop_unalwaysontop {
    if [[ "$ALWAYSONTOP" == "TRUE"  ]]
    then
        export ALWAYSONTOP="FALSE"

        add-zsh-hook -d precmd alwaysontop_gototop
    fi
}

function alwaysontop_autoclear {
    if [[ "$AUTOCLEAR" != "TRUE" ]]
    then
        export AUTOCLEAR="TRUE"
        
        # make a copy of the original accept line, and use our own widget which calls it after clearing the screen
        zle -A accept-line original-accept-line
        function accept-line {
            zle clear-screen
            zle original-accept-line
        }
        zle -N accept-line
    fi
}


function alwaysontop_unautoclear {
    if [[ "$AUTOCLEAR" != "FALSE" ]]
    then
        export AUTOCLEAR="FALSE"

        zle -A original-accept-line accept-line
    fi
}


# turn on both alwaysontop and autoclear
function alwaysontop_autotop {
    clear
    alwaysontop_autoclear
    alwaysontop_alwaysontop
}

# turn off both alwaysontop and autoclear
function alwaysontop_unautotop {
    alwaysontop_unalwaysontop
    alwaysontop_unautoclear
}

function alwaysontop_status {
    if [[ "$ALWAYSONTOP" = "TRUE" ]]
    then
        echo -e "${COLOR_BIPurple}Always on top:${COLOR_off} ${COLOR_BGreen}ON${COLOR_off}."
    else
        echo -e "${COLOR_BIPurple}Always on top:${COLOR_off} ${COLOR_BGreen}OFF${COLOR_off}."
    fi

    if [[ "$AUTOCLEAR" = "TRUE" ]]
    then
        echo -e "${COLOR_BIYellow}Auto clear   :${COLOR_off} ${COLOR_BGreen}ON${COLOR_off}."
    else
        echo -e "${COLOR_BIYellow}Auto clear   :${COLOR_off} ${COLOR_BGreen}OFF${COLOR_off}."
    fi
}

function alwaysontop_help {
    #alwaysontop_status
    #
    #echo -e "    "
    #echo -e "    autotop           Turn ${COLOR_BGreen}ON${COLOR_off} always on top and autoclear"
    #echo -e "    unautotop         Turn ${COLOR_BRed}OFF${COLOR_off} always on top and autoclear"
    #echo -e "    "                 
    #echo -e "    alwaysontop       Turn ${COLOR_BGreen}ON${COLOR_off} always on top"
    #echo -e "    unalwaysontop     Turn ${COLOR_BRed}OFF${COLOR_off} always on top"
    #echo -e "    "                 
    #echo -e "    autoclear         Turn ${COLOR_BGreen}ON${COLOR_off} clear-screen after each command."
    #echo -e "    unautoclear       Turn ${COLOR_BRed}OFF${COLOR_off} clear-screen after each command."

echo \
"@see https://github.com/truchi/alwaysontop

Usage: $1 (autotop|unautotop|alwaysontop|unalwaysontop|autoclear|unautoclear)

  lol                        emit lol messages
  -C, --config-file=FILE     use this user configuration file
  -d, --debug                emit debugging messages
  -D, --default              reset all options to their default values
      --warnings[=WARNINGS]  enable warnings from groff

Mandatory or optional arguments to long options are also mandatory or optional
for any corresponding short options.

Report bugs to cjwatson@debian.org."
}

function alwaysontop {
    NAME=$0
    
    case $1 in
        autotop) alwaysontop_autotop; alwaysontop_status
        ;;
        unautotop) alwaysontop_unautotop; alwaysontop_status
        ;;
        alwaysontop) alwaysontop_alwaysontop; alwaysontop_status
        ;;
        unalwaysontop) alwaysontop_unalwaysontop; alwaysontop_status
        ;;
        autoclear) alwaysontop_autoclear; alwaysontop_status
        ;;
        unautoclear) alwaysontop_unautoclear; alwaysontop_status
        ;;
        *) alwaysontop_help $NAME
        ;;
    esac
}

COLOR_off='\033[0m' 
COLOR_BIPurple='\033[1;95m' 
COLOR_BIYellow='\033[1;93m'
COLOR_BGreen='\033[1;32m'
COLOR_BRed='\033[1;31m'

# setup the colors used here
autoload -U colors && colors
autoload -U add-zsh-hook
alwaysontop_zcurses_init

# Completions
# compdef _gnu_generic alwaysontop
# compdef "_describe 'command' 'c:lalalallal lol' 'd:dddddd'" alwaysontop

alwaysontop_autotop
echo "    "  


