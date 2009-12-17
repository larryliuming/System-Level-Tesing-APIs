note
	description: "[
					Ancestor for all execution instructions
																								]"
	legal: "See notice at end of class."
	status: "See notice at end of class."
	keywords: "Eiffel test"
	date: "$Date: 2009-06-04 08:11:49 +0800 (四, 04  6月 2009) $"
	revision: "$Revision: 79073 $"

deferred class
	EQA_EW_EXECUTE_INST

inherit
	EQA_EW_TEST_INSTRUCTION

feature {NONE} -- Initialization

	make (a_line: STRING)
			-- Creation method
		do
			inst_initialize (a_line)
		end

	inst_initialize (a_line: STRING)
			-- Initialize instruction from `a_line'.  Set
			-- `init_ok' to indicate whether
			-- initialization was successful.
		local
			l_args: LIST [STRING]
		do
			l_args := string_util.broken_into_words (a_line)
			if l_args.count < 2 then
				init_ok := False
				failure_explanation := "must have at least 2 arguments"
			else
				input_file_name := l_args.i_th (1)
				output_file_name := l_args.i_th (2)
				if equal (input_file_name, No_file_name) then
					input_file_name := Void
				end
				if equal (output_file_name, No_file_name) then
					output_file_name := Void
				end
				create arguments.make (l_args.count - 2)
				from
					l_args.start
					l_args.forth
					l_args.forth
				until
					l_args.after
				loop
					arguments.extend (l_args.item)
					l_args.forth
				end
				init_ok := True
			end
		end

feature -- Query

	init_ok: BOOLEAN
			-- Was last call to `initialize' successful?

	execute_ok: BOOLEAN
			-- Was last call to `execute' successful?

feature -- Command

	execute (a_test: EQA_EW_SYSTEM_TEST_SET)
			-- Execute `Current' as one of the
			-- instructions of `a_test'.
			-- Set `execute_ok' to indicate whether successful.
		local
			l_prog, l_exec_dir, l_infile, l_outfile, l_savefile: STRING
			l_execute_cmd, l_exec_error: STRING
			l_prog_file, l_input_file: RAW_FILE
			l_execution: EQA_EW_SYSTEM_EXECUTION
			l_path: EQA_SYSTEM_PATH
		do
			l_execute_cmd := a_test.environment.value ({EQA_EW_PREDEFINED_VARIABLES}.Execute_command_name)
			l_execute_cmd := a_test.environment.substitute (l_execute_cmd)
			l_exec_error := executable_file_error (l_execute_cmd)
			if l_exec_error = Void then
				a_test.increment_execution_count
				l_exec_dir := a_test.environment.value (execution_dir_name)
--				create l_path.make (<<l_exec_dir, a_test.system_name>>)
				l_prog := string_util.file_path (<<l_exec_dir, "test">>) -- FIXME: who set the name `test'?
				if input_file_name /= Void then
					l_infile := string_util.file_path (<<a_test.environment.value ({EQA_EW_PREDEFINED_VARIABLES}.Source_dir_name), input_file_name>>)
				else
					l_infile := Void
				end
				l_outfile := Void	-- Pipe output back to parent
				if output_file_name /= Void and then not output_file_name.is_empty then
					l_savefile := output_file_name
				else
					l_savefile := a_test.execution_output_name
				end

				l_savefile := string_util.file_path (<<a_test.environment.value ({EQA_EW_PREDEFINED_VARIABLES}.Output_dir_name), l_savefile>>)

				create l_prog_file.make (l_prog)
				l_exec_error := executable_file_error (l_prog)
				if l_exec_error = Void then
					execute_ok := True
					if l_infile /= Void then
						create l_input_file.make (l_infile)
						if not l_input_file.exists then
							failure_explanation := "input file not found"
							execute_ok := False
						elseif not l_input_file.is_plain then
							failure_explanation := "input file not a plain file"
							execute_ok := False
						end
					end
					if execute_ok then
						create l_execution.make (l_prog, arguments, l_execute_cmd, l_exec_dir, l_infile, l_outfile, l_savefile, a_test)
					end
				else
					failure_explanation := l_exec_error
					execute_ok := False
				end

			else
				failure_explanation := l_exec_error
				execute_ok := False
			end

			assert.assert (failure_explanation, execute_ok)
		end

feature {NONE} -- Constants

	No_file_name: STRING = "NONE"
			-- Constant for no file name

feature {NONE} -- Implementation

	input_file_name: STRING
			-- Name of input file

	output_file_name: STRING
			-- Name of output file

	arguments: ARRAYED_LIST [STRING]
			-- Arguments

	execution_dir_name: STRING
			-- Name of directory where executable resides
		deferred
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
