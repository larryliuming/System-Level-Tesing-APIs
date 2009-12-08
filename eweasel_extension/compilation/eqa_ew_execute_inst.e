note
	description: "Summary description for {EQA_EW_EXECUTE_INST}."
	date: "$Date$"
	revision: "$Revision$"

deferred class
	EQA_EW_EXECUTE_INST

inherit
	EQA_EW_TEST_INSTRUCTION

feature -- Query

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
				create l_path.make (<<l_exec_dir, a_test.system_name>>)
				l_prog := l_path.as_string
				if input_file_name /= Void then
					create l_path.make (<<a_test.environment.value ({EQA_EW_PREDEFINED_VARIABLES}.Source_dir_name), input_file_name>>)
					l_infile := l_path.as_string
				else
					l_infile := Void
				end
				l_outfile := Void;	-- Pipe output back to parent
				if output_file_name /= Void then
					l_savefile := output_file_name
				else
					l_savefile := a_test.execution_output_name
				end
				create l_path.make (<<a_test.environment.value ({EQA_EW_PREDEFINED_VARIABLES}.Output_dir_name), l_savefile>>)
				l_savefile := l_path.as_string

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
--						a_test.set_execution_result (l_execution.next_execution_result)
					end
				else
					failure_explanation := l_exec_error
					execute_ok := False
				end

			else
				failure_explanation := l_exec_error
				execute_ok := False
			end
		end

feature {NONE} -- Implementation

	input_file_name: STRING
			-- Name of input file

	output_file_name: STRING
			-- Name of output file

	arguments: LINKED_LIST [STRING]
			-- Arguments

	execution_dir_name: STRING
			-- Name of directory where executable resides
		deferred
		end

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
