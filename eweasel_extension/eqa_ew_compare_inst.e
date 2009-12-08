note
	legal: "See notice at end of class."
	status: "See notice at end of class."
	keywords: "Eiffel test"
	date: "93/08/30"

class EQA_EW_COMPARE_INST

inherit
	EQA_EW_TEST_INSTRUCTION
--	EW_PREDEFINED_VARIABLES
--	EW_STRING_UTILITIES
--	EW_OS_ACCESS

create
	make

feature {NONE} -- Initialization

	make (a_line: STRING)
			-- Initialize instruction from `a_line'.  Set
			-- `init_ok' to indicate whether
			-- initialization was successful.
		local
			l_args: LIST [STRING]
		do
			l_args := string_util.broken_into_words (a_line)
			if l_args.count /= 2 then
				failure_explanation := "argument count must be 2"
				init_ok := False
			else
				actual_output_file := l_args.i_th (1)
				expected_output_file := l_args.i_th (2)
				init_ok := True
			end
		end

feature -- Command

	execute (a_test: EQA_EW_SYSTEM_TEST_SET)
			-- Execute `Current' as one of the
			-- instructions of `a_test'.
			-- Set `execute_ok' to indicate whether successful.
		local
			l_act_name, l_exp_name: STRING
			l_actual, l_expected: RAW_FILE
			l_system_path: EQA_SYSTEM_PATH
		do
			execute_ok := False
			create l_system_path.make (<<a_test.environment.value ({EQA_EW_PREDEFINED_VARIABLES}.Output_dir_name), actual_output_file>>)
			l_act_name := l_system_path.as_string
			create l_system_path.make (<<a_test.environment.value ({EQA_EW_PREDEFINED_VARIABLES}.Source_dir_name), expected_output_file>>)
			l_exp_name := l_system_path.as_string
			create l_actual.make (l_act_name)
			create l_expected.make (l_exp_name)
			if (l_actual.exists and then l_actual.is_plain) and
			   (l_expected.exists and then l_expected.is_plain) then
				execute_ok := equal_files (l_actual, l_expected)
				if not execute_ok then
					failure_explanation := "files being compared do not have identical contents"
				end
			elseif not l_actual.exists then
				failure_explanation := "file with actual output not found"
			elseif not l_actual.is_plain then
				failure_explanation := "file with actual output not a plain file"
			elseif not l_expected.exists then
				failure_explanation := "file with expected output not found"
			elseif not l_expected.is_plain then
				failure_explanation := "file with expected output not a plain file"
			end

		end

	init_ok: BOOLEAN
			-- Was last call to `initialize' successful?

	execute_ok: BOOLEAN
			-- Was last call to `execute' successful?


feature {NONE}  -- Implementation

	equal_files (a_file1: RAW_FILE; a_file2: RAW_FILE): BOOLEAN
			-- Do `a_file1' and `a_file2' have identical contents?
		require
			source_not_void: a_file1 /= Void
			destination_not_void: a_file2 /= Void
		local
--			eof1, eof2, unequal: BOOLEAN
			l_diff: EQA_DIFF_UTILITY
			l_src, l_dst: ARRAY [STRING_GENERAL]
		do
			create l_diff.make

			l_src := file_content (a_file1).to_array
			l_dst := file_content (a_file2).to_array

			l_diff.compare (l_src, l_src)

			Result := (l_diff.differing_lines.count = 0) -- Note: we can use {EQA_DIFF_UTILITY} to show more infomation

--			from
--				a_file1.open_read
--				a_file2.open_read
--			until
--				eof1 or eof2 or unequal
--			loop
--				a_file1.readchar
--				a_file2.readchar
--				eof1 := a_file1.end_of_file
--				eof2 := a_file2.end_of_file
--				if not eof1 and not eof2 then
--					if a_file1.last_character /= a_file2.last_character then
--						unequal := True
--					end
--				elseif (eof1 and not eof2) or (eof2 and not eof1) then
--					unequal := True
--				end
--			end
--			a_file1.close
--			a_file2.close
--			Result := not unequal
		end

feature {NONE} -- Implementation

	file_content (a_file: RAW_FILE): ARRAYED_LIST [STRING]
			-- Content of `a_file'
		require
			not_empty: attached a_file
		do
			create Result.make (50)
			if a_file.exists then
				from
					a_file.open_read
					a_file.start
				until
					a_file.after
				loop
					a_file.read_line

					Result.extend (a_file.last_string)
				end
			end
		ensure
			not_void: attached Result
		end

	actual_output_file: STRING
			-- Name of file with actual output

	expected_output_file: STRING
			-- Name of file with expected output

	string_util: EQA_EW_STRING_UTILITIES
			-- String utilities
		once
			create Result
		end

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
