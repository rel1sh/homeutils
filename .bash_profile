if [ -e ~/.profile ]
then
	source ~/.profile
fi

# .bash_profile - bash startup script for login shells
#
# personal start-up file for Alex

export PS1='(\[$(tput md)\]\t <\h:\w>\[$(tput me)\]) $(echo $?) \$ '
export PATH=$HOME/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin
#export PATH=/home/alex/bin:/sbin:/bin:/usr/sbin:/usr/bin:/usr/games:/usr/local/sbin:/usr/local/bin:~vpopmail/bin:/var/qmail/bin
export LANG='en_US.UTF-8'
export COPYFILE_DISABLE=1

# BEGIN SNIPPET: Magento Cloud CLI configuration
HOME=${HOME:-'/Users/envoy'}
export PATH="$HOME/"'.magento-cloud/bin':"$PATH"
if [ -f "$HOME/"'.magento-cloud/shell-config.rc' ]; then . "$HOME/"'.magento-cloud/shell-config.rc'; fi # END SNIPPET

# set some node stuff
export NVM_DIR="$HOME/.nvm"
. "/usr/local/opt/nvm/nvm.sh"

# some useful command line aliases
alias astat='apachectl status'
alias afstat='apachectl fullstatus'
alias astatgrep='apachectl fullstatus | egrep'
alias aconfig='apachectl configtest'
alias clip='cut -c 1-80'
alias df='df -h'
alias digx='dig -x'
alias dip='dig -x'
alias du='du -h'
alias grep='grep -n'
alias greps='ps wwaux | head -n 1 && ps wwaux | egrep'
alias greptop='top -b 1 | head -n 8 && top -b all | egrep'
alias dgrep='cat /var/run/dmesg.boot | grep -i'
alias igrep='egrep -i'
alias ipre="egrep -o '([0-9]{1,3}\.){3}[0-9]{1,3}'"
alias ls='ls -lh'
alias lsd='ls -d'
alias rgrep='grep -rH'
alias rigrep='grep -irH'
alias s3sync='rsync -av --inplace'
alias myfetch='fetch -o /home/alex/pub'
alias pkgfetch='fetch -o /home/alex/package'
alias up='cd ..'
alias nocomments="egrep -v '^\#' | egrep -v '^$'"
alias sudo="sudo -E"
alias udiff='diff -u'

# do ssh-agent setup
source $HOME/.bash_include/ssh-agent.inc

