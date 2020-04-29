# Keep a copy of the original accept line
zle -A accept-line before-alwaysontop-accept-line

function alwaysontop_zcurses_init {
    zmodload zsh/curses
    zcurses init
    zcurses delwin aotwin
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
        ALWAYSONTOP="TRUE"

        add-zsh-hook precmd alwaysontop_gototop
    fi
}

function alwaysontop_unalwaysontop {
    if [[ "$ALWAYSONTOP" != "FALSE"  ]]
    then
        ALWAYSONTOP="FALSE"

        add-zsh-hook -d precmd alwaysontop_gototop
    fi
}

function alwaysontop_autoclear {
    if [[ "$AUTOCLEAR" != "TRUE" ]]
    then
        AUTOCLEAR="TRUE"

        # Use our own widget which calls original accept line after clearing the screen
        function accept-line {
            zle clear-screen
            zle before-alwaysontop-accept-line
        }
        
        zle -N accept-line
    fi
}

function alwaysontop_unautoclear {
    if [[ "$AUTOCLEAR" != "FALSE" ]]
    then
        AUTOCLEAR="FALSE"

        # Restore before-alwaysontop-accept-line
        function accept-line {
            zle before-alwaysontop-accept-line
        }
        
        zle -N accept-line
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
    alwaysontop_status
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

Commands:
  autotop           Turn ${COLOR_BGreen}ON${COLOR_off} always on top and autoclear
  unautotop         Turn ${COLOR_BRed}OFF${COLOR_off} always on top and autoclear

  alwaysontop       Turn ${COLOR_BGreen}ON${COLOR_off} always on top
  unalwaysontop     Turn ${COLOR_BRed}OFF${COLOR_off} always on top

  autoclear         Turn ${COLOR_BGreen}ON${COLOR_off} clear-screen after each command.
  unautoclear       Turn ${COLOR_BRed}OFF${COLOR_off} clear-screen after each command."
}

function alwaysontop {
    NAME=$0
    alwaysontop_zcurses_init

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


