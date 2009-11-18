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
