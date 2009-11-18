note
	description: "Summary description for {EQA_EW_OPERATING_SYSTEM}."
	date: "$Date$"
	revision: "$Revision$"

deferred class
	EQA_EW_OPERATING_SYSTEM

inherit
	EXECUTION_ENVIRONMENT
		export
			{NONE} all
		end

feature -- Date and time

	current_time_in_seconds: INTEGER
			-- Current time in seconds since the start of
			-- the epoch (00:00:00 GMT,  Jan.  1,  1970)
		deferred
		end

feature -- Sleeping

	sleep_milliseconds (n: DOUBLE)
			-- Suspend execution for `n' milliseconds.
			-- Actual time could be longer or shorter
		require
			nonnegative_time: n >= 0
		local
			l_nanosecs: INTEGER_64
		do
			l_nanosecs := (n * 1_000_000 + 0.5).truncated_to_integer_64
			sleep (l_nanosecs)
		end

note
	copyright: "Copyright (c) 1984-2009, Eiffel Software and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"
end
