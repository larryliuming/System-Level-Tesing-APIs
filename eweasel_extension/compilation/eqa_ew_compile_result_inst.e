note
	legal: "See notice at end of class."
	status: "See notice at end of class."
	keywords: "Eiffel test"
	date: "93/08/30"

class EQA_EW_COMPILE_RESULT_INST

--inherit
--	EW_TEST_INSTRUCTION
--	EW_STRING_UTILITIES

feature -- Query

	failure_explanation: STRING
			-- Explanation of why last `initialize' or
			-- `execute' which was not OK failed (Void
			-- if no explanation available)

feature -- Command

	execute (a_test: EQA_EW_SYSTEM_TEST_SET)
			-- Execute `Current' as one of the
			-- instructions of `test'.
			-- Set `execute_ok' to indicate whether successful.
		local
			l_cr: EQA_EW_EIFFEL_COMPILATION_RESULT
		do
			l_cr := a_test.e_compilation_result
			if l_cr = Void then
				execute_ok := False
				create failure_explanation.make (0)
				failure_explanation.append ("no pending Eiffel compilation result to check")

			else
				-- Make sure syntax and validity errors/warnings
				-- are sorted.  They might not be sorted even
				-- though they are sorted lists because items
				-- may be added before all key fields are set
				l_cr.sort
				execute_ok := l_cr.matches (expected_compile_result)
				if not execute_ok then
					create failure_explanation.make (0)
					failure_explanation.append ("actual compilation result does not match expected result%N")
					failure_explanation.append ("Actual result:%N")
					failure_explanation.append (l_cr.summary)
					failure_explanation.append ("%NExpected result:%N")
					failure_explanation.append (expected_compile_result.summary)
				end
				a_test.set_e_compilation_result (Void)
			end
		end

	init_ok: BOOLEAN
			-- Was last call to `initialize' successful?

	execute_ok: BOOLEAN
			-- Was last call to `execute' successful?

feature {NONE} -- Implementation

	expected_compile_result: EQA_EW_EIFFEL_COMPILATION_RESULT
			-- Result expected from compilation

	process_syntax_phrase (a_phrase: STRING; a_cr: EQA_EW_EIFFEL_COMPILATION_RESULT)
			-- Modify `cr' to reflect presence of syntax phrase
			-- `phrase'
		require
			phrase_not_void: a_phrase /= Void
			compile_result_not_void: a_cr /= Void
		local
			l_words: LIST [STRING]
			l_count: INTEGER
			l_cname, l_line_no: STRING
			l_syn: EQA_EW_EIFFEL_SYNTAX_ERROR
		do
			l_words := string_util.broken_into_words (a_phrase)
			l_count := l_words.count
			if l_count = 2 then
				l_cname := l_words.i_th (1)
				l_line_no := l_words.i_th (2)
			end
			if l_count /= 2 then
				init_ok := False
				create failure_explanation.make (0)
				failure_explanation.append ("wrong number of arguments for syntax error phrase: ")
				failure_explanation.append (a_phrase)
			elseif not string_util.is_integer (l_line_no) then
				init_ok := False
				create failure_explanation.make (0)
				failure_explanation.append ("syntax error has non-integer line number: ")
				failure_explanation.append (l_line_no)
			else
				l_cname := real_class_name (l_cname)
				create l_syn.make (l_cname)
				l_syn.set_line_number (l_line_no.to_integer)
				a_cr.add_syntax_error (l_syn)
			end

		end

	process_validity_phrase (a_phrase: STRING; a_cr: EQA_EW_EIFFEL_COMPILATION_RESULT)
			-- Modify `a_cr' to reflect presence of validity phrase
			-- `phrase'
		require
			phrase_not_void: a_phrase /= Void
			compile_result_not_void: a_cr /= Void
		local
			l_words: LIST [STRING]
			l_count: INTEGER
			l_cname: STRING
			l_val: EQA_EW_EIFFEL_VALIDITY_ERROR
		do
			l_words := string_util.broken_into_words (a_phrase)
			l_count := l_words.count
			if l_count < 2 then
				init_ok := False
				create failure_explanation.make (0)
				failure_explanation.append ("validity error phrase has less than 2 arguments: ")
				failure_explanation.append (a_phrase)
			else
				from
					l_words.start
					l_cname := real_class_name (l_words.item)
					l_words.forth
				until
					l_words.after
				loop
					create l_val.make (l_cname, l_words.item)
					a_cr.add_validity_error (l_val)
					l_words.forth
				end
			end
		end

	real_class_name (cname: STRING): STRING
			-- Actual class name to be used in expected
			-- compile result
		do
			if equal (cname, No_class_name) then
				create Result.make (0)
					-- Use empty string for real class name
			else
				Result := cname
			end
		end

	No_class_name: STRING = "NONE"

	Phrase_separator: CHARACTER = ';'

	Ok_result: STRING = "ok"

	Syntax_error_result: STRING = "syntax_error"

	Syntax_warning_result: STRING = "syntax_warning"

	Validity_error_result: STRING = "validity_error"

	Validity_warning_result: STRING = "validity_warning"

	string_util: EQA_EW_STRING_UTILITIES
			-- String utilities
		once
			create Result
		end

note
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
