note
	description: "[
					Ancestor for all Eiffel compilation instructions
																								]"
	legal: "See notice at end of class."
	status: "See notice at end of class."
	keywords: "Eiffel test"
	date: "$Date: 2009-06-04 08:11:49 +0800 (四, 04  6月 2009) $"
	revision: "$Revision: 79073 $"

deferred class
	EQA_EW_COMPILE_INST

inherit
	EQA_EW_TEST_INSTRUCTION
		export
			{NONE} all
		end

feature {NONE} -- Initialization

	make (a_output_file_name: detachable STRING)
			-- Creation method
			-- `a_output_file_name' can be void
		do
			output_file_name := a_output_file_name
		ensure
			set: output_file_name = a_output_file_name
		end

feature -- Query

	output_file_name: STRING
			-- Name of file where output from compile is
			-- to be placed

	execute_ok: BOOLEAN
			-- Was last call to `execute' successful?

;note
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
