# this theme depends on git plugin.

function str_with_color() {
    echo "%{$fg[$1]%}$2%{$reset_color%}"
}

ZSH_THEME_GIT_PROMPT_ADDED=$(str_with_color green ' A')
ZSH_THEME_GIT_PROMPT_MODIFIED=$(str_with_color yellow ' M')
ZSH_THEME_GIT_PROMPT_DELETED=$(str_with_color red ' D')
ZSH_THEME_GIT_PROMPT_RENAMED=$(str_with_color blue ' R')
ZSH_THEME_GIT_PROMPT_UNMERGED=$(str_with_color magenta ' U')
ZSH_THEME_GIT_PROMPT_UNTRACKED=$(str_with_color grey ' ?')
ZSH_THEME_GIT_PROMPT_AHEAD=$(str_with_color cyan ' ↑ ')
ZSH_THEME_GIT_PROMPT_BEHIND=$(str_with_color cyan ' ↓ ')

function my_git_status() {
    [ $(current_branch) ] && echo "| $(current_branch)$(git_prompt_status)"
}

function my_rbenv_version() {
    if [ -f $HOME/.anyenv/envs/rbenv/bin/rbenv ] || [ -f $HOME/.rbenv/bin/rbenv ]; then
        echo " rb@"$(rbenv version | sed -e "s/ (set.*$//")
    fi
}

function my_pyenv_version() {
    if [ -f $HOME/.anyenv/envs/pyenv/bin/pyenv ] || [ -f $HOME/.pyenv/bin/pyenv ]; then
        echo " py@"$(pyenv version | sed -e "s/ (set.*$//")
    fi
}

function my_goenv_version() {
    if [ -f $HOME/.anyenv/envs/goenv/bin/goenv ] || [ -f $HOME/.goenv/bin/goenv ]; then
        echo " go@"$(goenv version | sed -e "s/ (set.*$//")
    fi
}

function my_ndenv_version() {
    if [ -f $HOME/.anyenv/envs/ndenv/bin/ndenv ] || [ -f $HOME/.ndenv/bin/ndenv ]; then
        echo " nd@"$(ndenv version | sed -e "s/ (set.*$//")
    fi
}

DATE_TIME=$(str_with_color yellow '%D{%Y/%m/%d %K:%M}')
PROMPT_PREFIX=$(str_with_color white '╭ ● ')
USER_NAME=$(str_with_color blue '%n')
HOST_NAME=$(str_with_color cyan '%m')
CURRENT_DIRECTORY=$(str_with_color green '%~')
PROMPT_CHAR=$(str_with_color white '╰ ○ ')
ENV_VERSIONS=$(str_with_color red "$(my_rbenv_version)")$(str_with_color green "$(my_pyenv_version)")$(str_with_color magenta "$(my_goenv_version)")$(str_with_color cyan "$(my_ndenv_version)")
SEPARATOR1=$(str_with_color white '@')
SEPARATOR2=$(str_with_color white ':')
SEPARATOR3=$(str_with_color white '<')
SEPARATOR4=$(str_with_color white '|')
SEPARATOR5=$(str_with_color white '>')
PROMPT='${PROMPT_PREFIX} ${USER_NAME}${SEPARATOR1}${HOST_NAME}${SEPARATOR2}${CURRENT_DIRECTORY} $(my_git_status)
$PROMPT_CHAR '
PROMPT2=$(str_with_color white '   > ')
RPROMPT='${SEPARATOR3}${ENV_VERSIONS} ${SEPARATOR4} ${DATE_TIME} ${SEPARATOR5}'
setopt transient_rprompt

