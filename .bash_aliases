alias ls='ls $LS_OPTIONS -hF'
alias ll='ls $LS_OPTIONS -lhF'
alias l='ls $LS_OPTIONS -lAhF'
alias cd..="cd .."
alias c="clear"
alias e="exit"
alias ssh="ssh -X"
alias ..="cd .."
alias sg="./script/generate"
alias ss="./script/server"
alias sc="./script/console"
alias ss="./script/server"
alias bd="open ~/tm/biodiversity.tmproj"
alias gn="open ~/tm/gni.tmproj"
alias tm='open ~/tm/taxamatch.tmproj'
alias e='open ~/tm/eol.tmproj'
alias lev='open ~/tm/levenshtein_playground.tmproj'
alias apache2ctl='sudo /opt/local/apache2/bin/apachectl'
alias gb="git branch"
alias gba="git branch -a"
alias gc="git commit -v"
alias gd="git diff | mate"
alias gl="git pull"
alias gp="git push"
alias gst="git status"
alias svim="screen -t vim 1 vim"
alias sr="screen -r"
alias sshg='ssh root@gniprod'
alias devpush='git push origin +dev'
alias dl="cd ~/dl;clear;ls"
alias tmp="cd ~/tmp;clear"
alias hl="heroku logs"
alias sel_test='cd ~/code/eol && time rake test:acceptance:web'
alias eol='cd ~/code/eol;clear'
alias eolphp='cd ~/code/eol_php_code'
alias ggr='git grep -n --color'
alias grdebug='git grep -n --color -l "^ *debugger"| grep -v vendor'
alias epopulate="rake truncate; rake scenarios:load NAME=bootstrap"
alias gni="cd ~/code/gni;clear"
alias sp="./script/spec"
alias 19='rvm 1.9.2-p0; echo "activating ruby 1.9.2"'
alias 18='rvm 1.8.7;echo "activating ruby 1.8.7"'

if [ -f $HOME/.bash_aliases_local ]; then
  source $HOME/.bash_aliases_local
fi
