note
	description: "Summary description for {EQA_EW_START_COMPILE_INST}."
	date: "$Date$"
	revision: "$Revision$"

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
			l_file_name: EQA_SYSTEM_PATH
		do
			-- Work around a bug in Eiffel 4.2 (can't start
			-- es4 on existing project unless project directory
			-- is current directory

			l_curr_dir := current_working_directory
			l_test_dir := a_test.environment.value ({EQA_EW_PREDEFINED_VARIABLES}.Test_dir_name)
			-- FIXME: remove if -project_path works
			-- if test_dir /= Void then
			-- 	change_working_directory (test_dir);
			-- end
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
--					create l_file_name.make (<<a_test.environment.value ({EQA_EW_PREDEFINED_VARIABLES}.Output_dir_name), l_name>>)
					create l_file_name.make (<<l_name>>)
--					l_name := os.full_file_name (,)
					l_name := l_file_name.as_string
					create l_compilation.make (l_compile_cmd, compiler_arguments (a_test, a_test.environment), l_name, a_test)
					a_test.set_e_compilation (l_compilation)
--					a_test.set_e_compilation_result (l_compilation.next_compile_result)
--					execute_ok := True
				else
					assert.assert (l_exec_error, False)
--					failure_explanation := exec_error
--					execute_ok := False
				end
			else
				assert.assert ("suspended compilation in progress", False)
--				failure_explanation := "suspended compilation in progress"
--				execute_ok := False
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
			create l_file_name.make (<<a_env.value ({EQA_EW_PREDEFINED_VARIABLES}.Test_dir_name), a_test.ecf_name>>)
			Result.extend (l_file_name.as_string)
--			Result.extend (os.full_file_name (, ))
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
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"
end
