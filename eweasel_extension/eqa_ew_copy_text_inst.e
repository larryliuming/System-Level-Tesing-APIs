note
	description: "Summary description for {EQA_EW_COPY_TEXT_INST}."
	date: "$Date$"
	revision: "$Revision$"

deferred class
	EQA_EW_COPY_TEXT_INST

inherit
	EQA_EW_COPY_INST

feature {NONE} -- Implementation

	new_file (a_file_name: STRING): PLAIN_TEXT_FILE
			-- <Precursor>
		do
			create Result.make (a_file_name)
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
