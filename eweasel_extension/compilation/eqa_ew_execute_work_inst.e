note
	description: "Summary description for {EQA_EW_EXECUTE_WORK_INST}."
	date: "$Date$"
	revision: "$Revision$"

class
	EQA_EW_EXECUTE_WORK_INST

inherit
	EQA_EW_EXECUTE_INST

feature {NONE} -- Implementation

	execution_dir_name: STRING
			-- Name of directory where executable resides
		once
			Result := {EQA_EW_PREDEFINED_VARIABLES}.Work_execution_dir_name
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
