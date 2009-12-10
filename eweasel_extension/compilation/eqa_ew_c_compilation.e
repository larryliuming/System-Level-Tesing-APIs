note
	description: "A C compilation"
	legal: "See notice at end of class."
	status: "See notice at end of class."
	keywords: "Eiffel test"
	date: "93/08/30"

class EQA_EW_C_COMPILATION

--inherit
--	EW_EWEASEL_PROCESS
--		rename
--			make as process_make
--		end

create
	make

feature {NONE} -- Initialization

	make (a_dir, a_save, a_freeze_cmd: STRING a_max_procs: INTEGER; a_test_set: EQA_EW_SYSTEM_TEST_SET)
			-- Start a new process to do any necessary
			-- C compilations (freezing) in directory `a_dir',
			-- using at most `a_max_procs' simultaneous processes
			-- to do C compilations.
			-- Write all output from the new process to
			-- file `a_save'.
		require
			directory_not_void: a_dir /= Void
			save_name_not_void: a_save /= Void
			not_void: attached a_test_set
		local
			l_args: ARRAYED_LIST [STRING]
--			l_system_process: EQA_SYSTEM_EXECUTION_PROCESS
			l_processor: EQA_EW_C_COMPILATION_OUTPUT_PROCESSOR
		do
			a_test_set.environment.put (a_freeze_cmd, "EQA_EXECUTABLE") -- How to get {EQA_SYSTEM_EXECUTION}.executable_env ?

			create l_args.make (4)
			l_args.extend (a_dir)
			if a_max_procs > 0 then
				l_args.extend ("-nproc")
				l_args.extend (a_max_procs.out)
			end

			create l_processor.make (a_test_set)
			a_test_set.set_output_processor (l_processor)
			a_test_set.run_system (l_args.to_array)
--			create l_system_process.make (l_processor, l_processor,
--			process_make (Shell_command, args, Void, Void, a_save)
			l_processor.write_output_to_file
			a_test_set.set_c_compilation_result (l_processor.compilation_result)
		end

	next_compile_result: EQA_EW_C_COMPILATION_RESULT
			--
		local
			time_to_stop: BOOLEAN
		do
--			create Result
--			from
--				read_line
--			until
--				end_of_file or time_to_stop
--			loop
--				savefile.put_string (last_string)
--				savefile.new_line
--				savefile.flush
--				Result.update (last_string)
--				if suspended then
--					time_to_stop := True
--				else
--					read_line
--				end
--			end
--			if end_of_file then
--				terminate
--			end
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
