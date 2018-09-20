# utility functions for logging
function log () {
	if [ -n "$VERBOSE" ]
	then
		echo "$@"
	fi
}

function log_debug () {
	echo "$@"
}
