note
	description: "Summary description for {EQA_EW_UNIX_OS}."
	date: "$Date$"
	revision: "$Revision$"

class
	EQA_EW_UNIX_OS

inherit
	EQA_EW_OPERATING_SYSTEM

feature -- Query

	current_time_in_seconds: INTEGER
			-- <Precursor>
		external
			"C inline use <time.h>"
		alias "[
  				time_t current_time;

  				current_time = time(&current_time);
  				if (current_time == (time_t) -1) {
    					eraise("time() call failed", EN_PROG);
  				}
  				return (EIF_INTEGER) current_time;
			]"
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