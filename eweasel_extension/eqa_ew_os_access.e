note
	description: "Summary description for {EQA_EW_OS_ACCESS}."
	date: "$Date$"
	revision: "$Revision$"

class
	EQA_EW_OS_ACCESS

feature -- Query

	os: EQA_EW_OPERATING_SYSTEM
			-- Access to generic operating system services
		once
			create {EQA_EW_UNIX_OS} Result
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
