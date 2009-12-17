note
	description: "[
					Document not found...
																								]"
	legal: "See notice at end of class."
	status: "See notice at end of class."
	keywords: "Eiffel test"
	date: "$Date: 2009-06-04 08:11:49 +0800 (四, 04  6月 2009) $"
	revision: "$Revision: 79073 $"

deferred class
	EQA_EW_START_COMPILE_INST

inherit
	EQA_EW_COMPILE_INST

	EXECUTION_ENVIRONMENT
		export
			{NONE} all
		end

	EQA_EW_OS_ACCESS
		export
			{NONE} all
		end

feature -- Command

	execute (a_test: EQA_EW_SYSTEM_TEST_SET)
			-- <Precursor>
		local
			l_name, l_compile_cmd, l_exec_error: STRING
			l_compilation: EQA_EW_EIFFEL_COMPILATION
			l_curr_dir, l_test_dir: STRING
--			l_file_name: EQA_SYSTEM_PATH
		do
			-- Work around a bug in Eiffel 4.2 (can't start
			-- es4 on existing project unless project directory
			-- is current directory

			l_curr_dir := current_working_directory
			l_test_dir := a_test.environment.value ({EQA_EW_PREDEFINED_VARIABLES}.Test_dir_name)

			l_compilation := a_test.e_compilation
			if l_compilation = Void or else not l_compilation.suspended then
				l_compile_cmd := a_test.environment.value ({EQA_EW_PREDEFINED_VARIABLES}.Compile_command_name)
				l_compile_cmd := a_test.environment.substitute_recursive (l_compile_cmd)
				l_exec_error := executable_file_error (l_compile_cmd)
				if l_exec_error = Void then
					a_test.increment_e_compile_count
					a_test.set_e_compile_start_time (os.current_time_in_seconds)
					if output_file_name /= Void and then not output_file_name.is_empty then
						l_name := output_file_name
					else
						l_name := a_test.e_compile_output_name
					end
--					create l_file_name.make (<<l_name>>)

--					l_name := l_file_name.as_string
					create l_compilation.make (l_compile_cmd, compiler_arguments (a_test, a_test.environment), l_name, a_test)
					a_test.set_e_compilation (l_compilation)

					execute_ok := True
				else
					failure_explanation := l_exec_error
					execute_ok := False
					assert.assert (l_exec_error, False)
				end
			else
				assert.assert ("suspended compilation in progress", False)
				failure_explanation := "suspended compilation in progress"
				assert.assert (failure_explanation, False)
			end
			change_working_directory (l_curr_dir)
		end

feature {NONE} -- Query

	compiler_arguments (a_test: EQA_EW_SYSTEM_TEST_SET; a_env: EQA_SYSTEM_ENVIRONMENT): LINKED_LIST [STRING]
			-- The arguments to the compiler for test `test'.
		local
			l_file_name: EQA_SYSTEM_PATH
		do
			create Result.make
			from
				compilation_options.start
			until
				compilation_options.after
			loop
				Result.extend (compilation_options.item)
				compilation_options.forth
			end;
				-- Add compilation dir to avoid changing
				-- working directory, which does not work
				-- with multithreaded code
			Result.extend ("-project_path")
			Result.extend (a_env.value ({EQA_EW_PREDEFINED_VARIABLES}.Test_dir_name))
				-- Ignore user file for testing
			Result.extend ("-local")
				-- Path to configuration file
			Result.extend ("-config")
			Result.extend (string_util.file_path (<<a_env.value ({EQA_EW_PREDEFINED_VARIABLES}.Test_dir_name), a_test.ecf_name>>))
		end

	compilation_options: LIST [STRING]
			-- Options to be passed to Eiffel compiler,
			-- if Eiffel compiler is run
		deferred
		ensure
			result_exists: Result /= Void
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
