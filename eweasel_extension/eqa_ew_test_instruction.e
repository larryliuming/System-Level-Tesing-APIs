note
	description: "Summary description for {EQA_EW_TEST_INSTRUCTION}."
	date: "$Date$"
	revision: "$Revision$"

deferred class
	EQA_EW_TEST_INSTRUCTION

feature -- Query

	execute_ok: BOOLEAN
			-- Was last call to `execute' successful?
		deferred
		end

	failure_explanation: STRING
			-- Explanation of why last `initialize' or
			-- `execute' which was not OK failed (Void
			-- if no explanation available)

feature -- Command

	execute (a_test: EQA_EW_SYSTEM_TEST_SET)
			-- Execute `Current' as one of the
			-- instructions of `test'.
			-- Set `execute_ok' to indicate
			-- whether execution was successful.
			-- Set `test_execution_terminated' to indicate
			-- whether execution of test should be terminated
			-- after this instruction
		require
			test_not_void: attached a_test
		deferred
		ensure
			explain_if_failure: (not execute_ok) implies failure_explanation /= Void
		end

feature {NONE} -- Utilities

	executable_file_error (a_s: STRING): STRING
			-- If file `a_s' does not exist or is not a file or
			-- is not executable, string describing the
			-- problem.  Void otherwise
		local
			l_f: RAW_FILE
			l_fname: STRING
		do
			if a_s /= Void then
				l_fname := a_s
			else
				l_fname := "(Void file name)"
			end
			create l_f.make (l_fname)
			if not l_f.exists then
				Result := "file " + l_fname + " not found"
			elseif not l_f.is_plain then
				Result := "file " + l_fname + " not a plain file"
			elseif not l_f.is_executable then
				Result := "file " + l_fname + " not executable"
			end
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
