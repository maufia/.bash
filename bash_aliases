#!/usr/bash
#--------------------------------------------------
# bash settings
# ??
umask 022

# set bell off
case "$TERM" in
    linux*)
        ;;
    *)
        xset -b b  off
        ;;
esac

# set listing taking into account capital/small letter
export LC_COLLATE=C

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# Open with xdg-open
alias ']'='xdg-open'

#--------------------------------------------------
# prompt settings

# Shorten Prompt by 3
export PROMPT_DIRTRIM=0
shortp() {
    if [ "$#" == 1 ]; then
        PROMPT_DIRTRIM=$1
    else
        PROMPT_DIRTRIM=3
    fi
}

longp() {
    PROMPT_DIRTRIM=0
}

function short_prompt() {
	MY_SHORT_PROMPT=`python ~/.bash//shortprompt.py $PROMPT_N_CHARS_TOTAL $PROMPT_N_CHARS_END`
    PS1="$(echo -n $(virtenv_prompt))\
\[\e[0;32m\]\u\[\e[0;37m\]:\
\[\e[1;31m\]$(echo -n $MY_SHORT_PROMPT)\
\[\e[0m\] -> "
}

## Shorten pompt
function shortpp() {
    export PROMPT_N_CHARS_TOTAL=5
    export PROMPT_N_CHARS_END=2
    if [ $# -ge 1 ]; then
        PROMPT_N_CHARS_TOTAL=$1
    fi
    if [ $# -eq 2 ]; then
        PROMPT_N_CHARS_END=$2
    fi
	PROMPT_COMMAND=short_prompt
}

function virtenv_prompt() {
if [[ -d $VIRTUAL_ENV ]]; then
       VIRTENV_NAME=$(/usr/bin/basename "$VIRTUAL_ENV")
       echo -n "($VIRTENV_NAME)"
   else
       echo -n ""
   fi
}

# standard prompt
function longpp() {
	PROMPT_COMMAND=""
    PS1="$(echo -n $(virtenv_prompt))\[\e[1;36m\][\$(date +%H:%M)]\
\[\e[0;32m\]\u\[\e[0;37m\]@\[\e[1;37m\]\h:\
\[\e[1;31m\]\w\[\e[0m\] -> "
}

case "$TERM" in
    xterm*|rxvt*|rxvt-unicode*|screen-256color*|linux*)
        PS1="\[\e[1;36m\][\$(date +%H:%M)]\
\[\e[0;32m\]\u\[\e[0;37m\]@\[\e[1;37m\]\h:\
\[\e[1;31m\]\w\[\e[0m\] -> "
		export LS_OPTIONS='--color=always'
esac
case "$TERM" in
    emacs*|dumb*)
		export PS1='\u -> '
		export LS_OPTIONS='--color=never'
esac

# Aliases
alias ls='ls -FC $LS_OPTIONS'
alias ll='ls -lh'
alias lla='ls -Alh'
alias la='ls -AX'
alias l='ls -CF'
alias lsv='ls --format=vertical'

alias ?='echo user: $USER; echo hostname: $HOSTNAME; echo dir: $PWD'

#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#DELETE
alias rm='/bin/mv --target-directory=$HOME/.trash $2'
delete() {
	/bin/rm -i $@
}
alias unbak='rm -v {*.*~,*.bak,.*~,*.flc}'

#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# GREP and FIND functions
findf()	{
	FINDFUSAGE="Usage: findf PATTERN";
	if [ "$#" = "0" ]; then
		echo $FINDFUSAGE
		echo "Try \`findf --help' for more information."
	elif [ "$1" = "--help" ]; then
		echo $FINDFUSAGE
		echo "Searches for files matching PATTERN in a directory hierarchy.";
		echo "The search is case insensitive"
		echo "Example:"
		echo "        findf \"?emp*\" "
	else
		find . -iname "$1" -print
	fi
}
SEARCHFILES='.c .cc .cpp .c++ .h .hpp .hh .pl .pm .sh .py .java .m .py .tex .sm';
findg() {
	FINDGUSAGE="Usage: findg [-a | FILE] PATTERN";
	if [ "$#" -eq 0 ]; then
		echo $FINDGUSAGE
		echo "Try \`findg --help' for more information."	
	elif [ "$1" = "--help" ]; then
		echo $FINDGUSAGE
		echo "Search for PATTERN in each FILE in a directory hierarchy."
		echo "Options:"
        echo "    -a, -all search every file \(ignoring binaries\)"
		echo "If only PARAMETER is given, only C, C++, Perl, Python,"
		echo "Latex, Shell and Matlab files are matched"
		echo "  "
	elif [ "$#" -eq 1 ]; then
		for ext in $SEARCHFILES; do
			find . -iname "*$ext" -print |xargs grep --color=yes -iIsn -A 1 -B 1 $1;
		done
	else
		if [ "$1" = "-all" ] || [ "$1" = "-a" ]; then
			find . -iname "*" -print |xargs grep --color=yes -iIsn -A 1 -B 1 $2;
		else
			find . -iname "$1" -print |xargs grep --color=yes -Isn $2;
		fi
	fi
}
grepy() {
	if [ "$#" = "0" ]; then
		echo ".bashrc: GREPY match pattern in all \".py\" files.";
		echo "         usage: grepy \"pattern\" ";
	else
		egrep --color=yes -iIsnd skip $1 *.py
	fi
}
grem() {
	if [ "$#" = "0" ]; then
		echo ".bashrc: GREM match pattern in all \".m\" files.";
		echo "         usage: grem \"pattern\" ";
	else
		egrep --color=yes -iIsnd skip $1 *.m
	fi
}
alias grep='grep --color=auto -d skip -iIsn $*'

#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#	EDITORS
#set vi editor
export EDITOR='vi'
eval $(lesspipe)
#eval $(lessfile)
em() {
	emacs --no-splash $* &
}
xe() {
	emacs --no-splash $* &
}
alias src='source $HOME/.bashrc;'
alias less='$HOME/bin/m'
alias m='$HOME/bin/m'

# vim should be handled by update-alternatives --config vim
alias vi='vim'
# Set pager using vimpager
export PAGER=/usr/bin/vimpager
export MANPAGER=/usr/bin/vimpager 


#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#	count n files
alias fcount="ls -1 |wc -l";

#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# LATEX
alias xdvi='/usr/bin/xdvi $* &'
untex(){
    if [ "$#" = "0" ]; then
        echo " .bashrc: UNTEX delete all latex files.";
        echo "          usage: untex FILE ";
    else
	    for ext in aux log dvi toc ps blg bbl out ind ilg idx pdf
        do
            /bin/rm "$1.${ext}"
        done
    fi
}

#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# PRINT
#export PRINTER=hp4350
export PRINTER=HP-BW
export PRINT_COMMAND="lp -d $PRINTER"
# normal printing
pr1() {
	if [ "$#" = "0" ]; then
		echo .bashrc: PR1 print on side only on $PRINTER
			#else a2ps -P$PRINTER $*
	else $PRINT_COMMAND $*;
	fi
}
# print two pages on one side only.
pr2() {
	if [ "$#" = "0" ]; then
		echo .bashrc: PR2 print two pages on one side only on $PRINTER
	else psnup -2 $* | psset -s > /tmp/print.ps;
		$PRINT_COMMAND /tmp/print.ps;
		/bin/rm /tmp/print.ps
	fi
}
# print two pages on one side only, meant for slides.
pr2_slide() {
	if [ "$#" = "0" ]; then
		echo .bashrc: PR2_SLIDE print two pages on one side only each
		echo          with landscape settings
	else psnup -2 $* | psset -t > /tmp/print.ps;
		$PRINT_COMMAND /tmp/print.ps;
		/bin/rm /tmp/print.ps
	fi
}
# print two pages on both side, with short edge binding
pr3() {
	if [ "$#" = "0" ]; then
		echo .bashrc: PR3 prints two pages on both side, with short edge binding
		echo          it does not work on hp4350. Use pr2
#		else psnup -2 $* | psset -t > /tmp/print.ps
#			$PRINT_COMMAND /tmp/print.ps;
#			/bin/rm /tmp/print.ps
	else
		echo pr3: Nothing printed...
	fi
}
pr4() {
	if [ "$#" = "0" ]; then
		echo .bashrc: PR4 print four pages on one side only
	else psnup -d -4 $* | psset -s > /tmp/print.ps;
		$PRINT_COMMAND /tmp/print.ps;
		/bin/rm /tmp/print.ps
	fi
}

#--------------------------------------------------
# TMUX
alias tmux='TERM=xterm-256color tmux -2 $@'
if [[ -d ".tmuxifier" ]]; then
    alias tmuxifier="TERM=xterm-256color $HOME/.tmuxifier/bin/tmuxifier s LINUX"
fi

#--------------------------------------------------
# Dos to unix functionality
dos2unix(){
  tr -d '\r' < "$1" > t
  mv -f t "$1"
}

unix2dos(){
  sed -i 's/$/\r/' "$1"
}

#--------------------------------------------------
# Python's Virtual Environment settings
# Remember to change virtualwrapper in /etc/bash_completion.d, as it
# uses /usr/share in place of /usr/local/bin/
if [ -f /usr/local/bin/virtualenvwrapper.sh ]; then
    export WORKON_HOME="$HOME/.virtualenvs"
    export PROJECT_HOME="$HOME/Python/PyVirtEnvs"
    export VIRTUALENVWRAPPER_PYTHON="/usr/bin/python3"
    export VIRTUALENVWRAPPER_SCRIPT="/usr/local/bin/virtualenvwrapper.sh"
    source /usr/local/bin/virtualenvwrapper.sh
fi

#--------------------------------------------------
# Anaconda path
#if ! echo $PATH | /bin/egrep -q "anaconda"* ; then
#    if [ -d $HOME/Python/Anaconda ]; then
#        # added by Miniconda installer
#        #export PATH="/home/mauro/Python/Anaconda/miniconda2/bin:$PATH"
#        export PATH="/home/mauro/Python/Anaconda/miniconda3/bin:$PATH"
#    fi
#fi

#--------------------------------------------------
# load bash colors file, must stay at the end
if [ -f $HOME/.bash_colors ]; then
    . $HOME/.bash_colors
fi

