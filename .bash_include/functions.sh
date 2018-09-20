# commonly included bash utility functions
function yesno () {
	# check for global "yes/no" set - do no prompting - NO takes precedence
	if [ -n "$NO" ]
	then
		return 1
	fi
	if [ -n "$YES" ]
	then
		return 0
	fi

	# check regular stuff
	if [ -z "$1" ]
		then
			PROMPT="Continue? [y|n] "
		else
			PROMPT="$1"
		fi

		read -n 1 -p "${PROMPT}" YN
		YNchk=`echo $YN | tr '[:upper:]' '[:lower:]'`
		if [[ "$YNchk" != "y" ]]
		then
			echo ""
			# see if we should return or quit
			if [ -n "$2" ]
			then
				return 1
			else
				echo "Quitting..."
				exit 0
			fi
	else
		echo ""
		if [ -n "$2" ]
		then
			return 0
		fi
	fi
}

function sleepdots () {
	# takes an int, sleeps for that many seconds and prints a dot as progress
	if [ -z "$1" ]
	then
		DOTS=1
	else
		DOTS="$1"
	fi

	while [ "$DOTS" -gt 0 ]
	do
		((DOTS--))
		echo -n "."
		sleep 1
	done
	echo ""
}
