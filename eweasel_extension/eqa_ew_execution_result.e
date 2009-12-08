note
	description: "An Eiffel system execution result"
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "93/08/30"

class EQA_EW_EXECUTION_RESULT

feature -- Properties

	execution_failure: BOOLEAN
			-- Did an explicit system execution failure
			-- occur during execution?

	had_panic: BOOLEAN
			-- Did a panic occur during execution?

	illegal_instruction: BOOLEAN
			-- Was an illegal instruction executed
			-- during execution?

	execution_finished: BOOLEAN
			-- Did execution finish normally (zero exit status)?

	summary: STRING
			-- Summary of `Current'
		local
			l_status: STRING
		do
			create Result.make (0)
			create l_status.make (0)
			if execution_finished and execution_failure then
				l_status.append ("completed_but_failed ")
			elseif execution_finished and not execution_failure then
				l_status.append ("completed ")
			elseif not execution_finished and execution_failure then
				l_status.append ("system_failed ")
			elseif not execution_finished and not execution_failure then
				l_status.append ("silent_failure ")
			end
			if had_panic then
				l_status.append ("had_panic ")
			end
			if illegal_instruction then
				l_status.append ("illegal_instruction ")
			end
			if l_status.count = 0 then
				l_status.append ("unknown	")
			end
			l_status.prepend ("%TFinal status:  ")
			Result.append (l_status)
		end

feature -- Modification

	set_execution_finished (a_b: BOOLEAN)
		do
			execution_finished := a_b
		end

	set_execution_failure (a_b: BOOLEAN)
		do
			execution_failure := a_b
		end


feature -- Update

	update (a_line: STRING)
			-- Update `Current' to reflect the presence of
			-- `a_line' as next line in execution output.
		local
			l_s: SEQ_STRING
			l_completed, l_failed: BOOLEAN
		do
			create l_s.make (a_line.count)
			l_s.append (a_line)
			l_s.to_lower
			l_s.start
			l_s.search_string_after (Panic_string, 0)
			if not l_s.after then
				had_panic := True
			end
			l_s.start
			l_s.search_string_after (System_failed_string, 0)
			if not l_s.after then
				execution_failure := True
			end
			l_s.start
			l_s.search_string_after (Illegal_inst_string, 0)
			if not l_s.after then
				illegal_instruction := True
			end
			l_s.start
			l_s.search_string_after (Completed_string, 0)
			l_completed := not l_s.after
			l_s.start
			l_s.search_string_after (Failed_string, 0)
			l_failed := not l_s.after
			if l_completed and not l_failed then
				execution_finished := True
			end
		end

feature -- Comparison

	matches (a_other: EQA_EW_EXECUTION_RESULT): BOOLEAN
			-- Do `Current' and `a_other' represent the
			-- same execution result?
		require
			other_not_void: a_other /= Void
		do
			Result := had_panic = a_other.had_panic and
				execution_failure = a_other.execution_failure and
				illegal_instruction = a_other.illegal_instruction
				and execution_finished = a_other.execution_finished
		end


feature {NONE} -- String constants

	Completed_string: STRING = "execution completed"

	Failed_string: STRING = "execution failed"

	System_failed_string: STRING = "system execution failed."

	Panic_string: STRING = "panic"

	Illegal_inst_string: STRING = "illegal instruction"

;note
	copyright: "Copyright (c) 1984-2009, Eiffel Software and others"
	license:   "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	copying: "[
			This file is part of the EiffelWeasel Eiffel Regression Tester.

			The EiffelWeasel Eiffel Regression Tester is free
			software; you can redistribute it and/or modify it under
			the terms of the GNU General Public License version 2 as published
			by the Free Software Foundation.

			The EiffelWeasel Eiffel Regression Tester is
			distributed in the hope that it will be useful, but
			WITHOUT ANY WARRANTY; without even the implied warranty
			of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
			See the GNU General Public License version 2 for more details.

			You should have received a copy of the GNU General Public
			License version 2 along with the EiffelWeasel Eiffel Regression Tester
			if not, write to the Free Software Foundation,
			Inc., 51 Franklin St, Fifth Floor, Boston, MA
		]"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"


end
