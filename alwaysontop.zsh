export PS1
export PROMPT_COMMAND

function _zcurses_init {
    zmodload zsh/curses
    zcurses init
    zcurses addwin aotwin $(tput lines) $(tput cols) 0 0
    zcurses end
}

function _gototop {
    zcurses init
    zcurses move aotwin 0 0
    zcurses end
}

function alwaysontop {
    if [[ "$ALWAYSONTOP" != "TRUE" ]]
    then
        export ALWAYSONTOP="TRUE"
        add-zsh-hook precmd _gototop
    fi
    
    echo -e "[alwaysontop.sh] ${COLOR_BIPurple}always on top${COLOR_off} ${COLOR_BGreen}ON${COLOR_off}."
}


function unalwaysontop {
    if [[ "$ALWAYSONTOP" == "TRUE"  ]]
    then
        export ALWAYSONTOP="FALSE"
        add-zsh-hook -d precmd _gototop
    fi
   
    echo -e "[alwaysontop.sh] ${COLOR_BIPurple}always on top${COLOR_off} ${COLOR_BRed}OFF${COLOR_off}."
}


function autoclear {
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
    
    echo -e "[alwaysontop.sh] ${COLOR_BIYellow}autoclear${COLOR_off} ${COLOR_BGreen}ON${COLOR_off}."
}


function unautoclear {
    export AUTOCLEAR="FALSE"
    zle -A original-accept-line accept-line
    echo -e "[alwaysontop.sh] ${COLOR_BIYellow}autoclear${COLOR_off} ${COLOR_BRed}OFF${COLOR_off}."
}


# turn on both alwaysontop and autoclear
function autotop {
    clear
    autoclear
    alwaysontop
}

# turn off both alwaysontop and autoclear
function unautotop {
    unalwaysontop
    unautoclear
}

function alwaysontop_help {
    echo -e "alwaysontop.zsh - keep the prompt at the top of the screen."
    echo -e "https://github.com/truchi/alwaysontop"
    echo -e "Romain TRUCHI, forked from:"
    echo -e "Peter Swire - swirepe.com"
    echo -e "Included commands:"
    echo -e "    "
    echo -e "    alwaysontop_help  This screen"
    echo -e "    "
    echo -e "    autotop           Turn ${COLOR_BGreen}ON${COLOR_off} always on top and autoclear"
    echo -e "    unautotop         Turn ${COLOR_BRed}OFF${COLOR_off} always on top and autoclear"
    echo -e "    "                 
    echo -e "    alwaysontop       Turn ${COLOR_BGreen}ON${COLOR_off} always on top"
    echo -e "    unalwaysontop     Turn ${COLOR_BRed}OFF${COLOR_off} always on top"
    echo -e "    "                 
    echo -e "    autoclear         Turn ${COLOR_BGreen}ON${COLOR_off} clear-screen after each command."
    echo -e "    unautoclear       Turn ${COLOR_BRed}OFF${COLOR_off} clear-screen after each command."
    echo -e "    "
    echo -e "    alwaysontop indicator:  ${COLOR_BIPurple}↑↑${COLOR_off}"
    echo -e "    autoclear indicator:    ${COLOR_BIYellow}◎${COLOR_off}"

}

COLOR_off='\033[0m' 
COLOR_BIPurple='\033[1;95m' 
COLOR_BIYellow='\033[1;93m'
COLOR_IBlack='\033[0;90m'
COLOR_BGreen='\033[1;32m'
COLOR_BRed='\033[1;31m'

# setup the colors used here
autoload -U colors && colors
autoload -U add-zsh-hook
_zcurses_init

autotop
echo "    "  


