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
			{EQA_EW_COPY_INST, EQA_EW_START_COMPILE_INST, EQA_EW_EIFFEL_COMPILATION} environment
			{EQA_EW_EIFFEL_COMPILATION} run_system
		end

	EQA_EW_OS_ACCESS
		export
			{NONE} all
		undefine
			default_create
		end

feature {NONE} -- Initialization

	initial_environment (a_env: EQA_SYSTEM_ENVIRONMENT; a_test_dir_name: STRING)
			-- Initial environment environment in which to
			-- execute `test'.  The result may be safely
			-- modified by the caller.
			-- Modified base on {EW_EQA_WINDOWS_SETUP}.initial_environment
		require
			test_not_void: a_env /= Void
		local
			l_test_dir, l_gen_dir, l_exec_dir: STRING
			l_path: DIRECTORY_NAME
			l_info: EQA_EVALUATION_INFO
		do
			create l_info
			create l_path.make_from_string (l_info.test_directory)

			l_test_dir := full_directory_name (l_path, a_test_dir_name) -- See {EWEASEL_TEST_CATALOG_SAMPLE}
			associate (a_env, {EQA_EW_PREDEFINED_VARIABLES}.Test_dir_name, l_test_dir)
			associate (a_env, {EQA_EW_PREDEFINED_VARIABLES}.Cluster_dir_name, full_directory_name (l_test_dir, "clusters"))
			associate (a_env, {EQA_EW_PREDEFINED_VARIABLES}.Output_dir_name, full_directory_name (l_test_dir, "output"))

			-- fixme ("set correct directory depending on used target")
			l_gen_dir := full_directory_name (l_test_dir, {EQA_EW_EIFFEL_TEST_CONSTANTS}.Eiffel_gen_directory)
			l_gen_dir := full_directory_name (l_gen_dir, {EQA_EW_EIFFEL_TEST_CONSTANTS}.Default_system_name)
			l_exec_dir := full_directory_name (l_gen_dir, {EQA_EW_EIFFEL_TEST_CONSTANTS}.Work_c_code_directory)
			a_env.put ({EQA_EW_PREDEFINED_VARIABLES}.Work_execution_dir_name, l_exec_dir)
			l_exec_dir := full_directory_name (l_gen_dir, {EQA_EW_EIFFEL_TEST_CONSTANTS}.Final_c_code_directory)
			a_env.put ({EQA_EW_PREDEFINED_VARIABLES}.Final_execution_dir_name, l_exec_dir)
		end

	associate (a_env: EQA_SYSTEM_ENVIRONMENT; a_var, a_dir: STRING)
			-- Define an environment variable `a_var' in the
			-- environment `a_env' to have
			-- value `a_dir', which must be a directory name.
			-- Create the directory `a_dir' if it does not exist.
		require
			environment_not_void: a_env /= Void
			var_name_not_void: a_var /= Void
			directory_not_void: a_dir /= Void
		local
			l_d: DIRECTORY
		do
			a_env.put (a_var, a_dir)
			create l_d.make (a_dir)
			if not l_d.exists then
				l_d.create_dir
			end
		end

	full_directory_name (a_path_1, a_path_2:STRING): STRING
			-- Full name of subdirectory `subdir' of directory
			-- `dir_name'
		local
			l_path: EQA_SYSTEM_PATH
		do
			create l_path.make (<<a_path_1, a_path_2>>)
			Result := l_path.as_string
		end

feature -- Query

	ecf_name: STRING
			-- Name of Ecf (ace) file for Eiffel compilations.

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

	e_compilation: EQA_EW_EIFFEL_COMPILATION
			-- Eiffel compilation, if any
			-- (possibly suspended and awaiting resumption)

	e_compile_count: INTEGER
			-- Number of Eiffel compilations started

	e_compile_output_name: STRING
			-- Name of file for output from current Eiffel
			-- compilation
		do
			create Result.make (0)
			Result.append (Eiffel_compile_output_prefix)
			Result.append_integer (e_compile_count)
		end

	e_compilation_result: EQA_EW_EIFFEL_COMPILATION_RESULT
			-- Result of the last Eiffel compilation.

feature -- Command

	unset_copy_wait
			-- Change status to indicate that no wait is
			-- needed before a file copy
		do
			unwaited_compilation := False
		ensure
			wait_not_required: not copy_wait_required
		end

	increment_e_compile_count
			-- Increment `e_compile_count' by 1
		do
			e_compile_count := e_compile_count + 1
		end

	set_e_compile_start_time (a_t: INTEGER)
			-- Set start time of last Eiffel compilation to `a_t'
		do
			e_compile_start_time := a_t
			unwaited_compilation := True
		ensure
			time_set: e_compile_start_time = a_t
			wait_required: unwaited_compilation
		end

	set_e_compilation (a_e: EQA_EW_EIFFEL_COMPILATION)
			-- Set `e_compilation' with `a_e'
		do
			e_compilation := a_e
		ensure
			set: e_compilation = a_e
		end

	set_e_compilation_result (a_e: EQA_EW_EIFFEL_COMPILATION_RESULT)
			-- Set `e_compilation_result' with `a_e'
		do
			e_compilation_result := a_e
		ensure
			set: e_compilation_result = a_e
		end

feature {EQA_EW_EIFFEL_COMPILATION} -- Internal command

	set_output_processor (a_processor: EQA_EW_OUTPUT_PROCESSOR)
			-- Set `a_process' as system execution output processor
		require
			not_void: attached a_processor
		local
			l_path: EQA_SYSTEM_PATH
		do
			create l_path.make (<<e_compile_output_name>>)
			prepare_system (l_path)
			current_execution.set_output_processor (a_processor)
			current_execution.set_error_processor (a_processor)
		end

feature {NONE} -- Implementation

	unwaited_compilation: BOOLEAN
			-- Is there a started or resumed compilation
			-- for which we have not yet waited and which
			-- may necessitate a wait?  (Due to the fact that
			-- the Eiffel compiler uses dates which
			-- only have a resolution of one second)

	Eiffel_compile_output_prefix: STRING = "e_compile"

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
