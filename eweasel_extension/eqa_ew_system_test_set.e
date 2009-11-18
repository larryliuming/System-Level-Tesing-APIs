note
	description: "[
					A Eweasel system test set base on Testing library
					
					For old version, please check {EW_EIFFEL_EWEASEL_TEST}
																			]"
	date: "$Date$"
	revision: "$Revision$"

class
	EQA_EW_SYSTEM_TEST_SET

inherit
	EQA_SYSTEM_TEST_SET
		export
			{EQA_EW_COPY_INST} environment
		end

	EQA_EW_OS_ACCESS
		export
			{NONE} all
		undefine
			default_create
		end

feature -- Query

	copy_wait_required: BOOLEAN
			-- Must we wait for one second before copying a
			-- file, in order to avoid a situation where the
			-- compiler does not recognize that a file has been
			-- modified?
		do
			Result := unwaited_compilation and os.current_time_in_seconds <= e_compile_start_time
		end

	e_compile_start_time: INTEGER
			-- Time in seconds since beginning of era
			-- when last Eiffel compilation was started or
			-- resumed
			
feature -- Command

	unset_copy_wait
			-- Change status to indicate that no wait is
			-- needed before a file copy
		do
			unwaited_compilation := False
		ensure
			wait_not_required: not copy_wait_required
		end

feature {NONE} -- Implementation

	unwaited_compilation: BOOLEAN
			-- Is there a started or resumed compilation
			-- for which we have not yet waited and which
			-- may necessitate a wait?  (Due to the fact that
			-- the Eiffel compiler uses dates which
			-- only have a resolution of one second)

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
