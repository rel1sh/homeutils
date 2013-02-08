# .profile - Bourne Shell startup script for login shells
#
# see also sh(1), environ(7).
#
# Alex's personal start-up file for bash
# PATH=/sbin:/bin:/usr/sbin:/usr/bin:/usr/games:/usr/local/sbin:/usr/local/bin:/usr/X11R6/bin:$HOME/bin; export PATH
export PS1='(\[$(tput md)\]\t <\h:\w>\[$(tput me)\]) $(echo $?) \$ '
export PATH=/home/alex/bin:/sbin:/bin:/usr/sbin:/usr/bin:/usr/games:/usr/local/sbin:/usr/local/bin:~vpopmail/bin:/var/qmail/bin

# some useful command line aliases
alias astat='apachectl status'
alias afstat='apachectl fullstatus'
alias astatgrep='apachectl fullstatus | egrep'
alias aconfig='apachectl configtest'
alias df='df -h'
alias digx='dig -x'
alias dip='dig -x'
alias du='du -h'
alias grep='grep -n'
alias greps='ps wwaux | head -n 1 && ps wwaux | egrep'
alias greptop='top -b 1 | head -n 8 && top -b all | egrep'
alias dgrep='cat /var/run/dmesg.boot | grep -i'
alias igrep='egrep -i'
alias ls='ls -lh'
alias lsd='ls -d'
alias rgrep='grep -rH'
alias rigrep='grep -irH'
alias myfetch='fetch -o /home/alex/pub'
alias sudo='sudo -E'
alias up='cd ..'
alias nocomments="egrep -v '^\#' | egrep -v '^$'"
alias udiff='diff -u'
alias wudo='sudo -u www'

# Define some colors first:
red='\e[0;31m'
RED='\e[1;31m'
blue='\e[0;34m'
BLUE='\e[1;34m'
cyan='\e[0;36m'
CYAN='\e[1;36m'
NC='\e[0m'              # No Color
# --> Nice. Has the same effect as using "ansi.sys" in DOS.

function _exit()	# function to run upon exit of shell
{
	echo -e "${RED}Peace out, bitches!${NC}"
}
trap _exit EXIT

# Setting TERM is normally done through /etc/ttys.  Do only override
# if you're sure that you'll never log in via telnet or xterm or a
# serial line.
# Use cons25l1 for iso-* fonts
# TERM=cons25; 	export TERM

BLOCKSIZE=K;	export BLOCKSIZE
EDITOR=vi;   	export EDITOR
PAGER=less;  	export PAGER
NO_GUI=true;	export NO_GUI

# set ENV to a file invoked each time sh is started for interactive use.
ENV=$HOME/.shrc; export ENV

[ -x /usr/games/fortune ] && /usr/games/fortune freebsd-tips
