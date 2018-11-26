usrlogd() {
        # get runtime directory
        if [ -z "$__BASH_CMD_CONTEXT" ]; then
                __BASH_CMD_CONTEXT="$PWD"
        fi
        __BASH_CMD_HISNO="$( history 1 | { read __BASH_CMD_HISNO __BASH_CMD_HISCMD; echo $__BASH_CMD_HISNO; } )"                      
        __BASH_CMD_HISCMD="$( history 1 | { read __BASH_CMD_HISNO __BASH_CMD_HISCMD; echo $__BASH_CMD_HISCMD; } )"                    
        # filter out ENTER and only log valuable user command
        # fix bug: "history -c" will clear all histories and __BASH_CMD_HISNO,__BASH_CMD_HISCMD will be empty                         
        # fix bug: ENTER in terminal will result __BASH_CMD_HISNO=__BASH_CMD_HISPRENO                                                 
        # fix bug: the latest command will be logged everytime when you launch a new terminal                                         
        # For now the terminal exit command will not be recorded
        if [ ! -z "$__BASH_CMD_HISPRENO" ] && [ ! -z "$__BASH_CMD_HISNO" ] && [ "$__BASH_CMD_HISNO" != "$__BASH_CMD_HISPRENO" ]; then 
                CMD_XXX="$( echo $__BASH_CMD_HISCMD | { read CMD_XXX CMD_IGNORE; echo $CMD_XXX; } )"                                  
                CMD_XXY="$( which $CMD_XXX 2>/dev/null )"
                if [ ! -z "$CMD_XXY" ]; then CMD_XXX=$CMD_XXY; fi
                CMD_YYY="$(echo $__BASH_CMD_HISCMD | { read CMD_IGNORE CMD_YYY; echo $CMD_YYY; } )"                                   
                MSG="$(who -m | { read x y z; echo "$x : TTY=$y ; PWD=$__BASH_CMD_CONTEXT ; USER=$x ; COMMAND=$CMD_XXX $CMD_YYY"; })" 
                logger -i -t usrlogd -p user.info "$MSG"
        fi
        # record command history ID
        __BASH_CMD_HISPRENO="$__BASH_CMD_HISNO"
        # update runtime directory
        __BASH_CMD_CONTEXT="$PWD"
}
# export usrlogd

PROMPT_COMMAND=usrlogd
