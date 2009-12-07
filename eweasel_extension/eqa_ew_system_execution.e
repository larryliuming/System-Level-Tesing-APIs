note
	description: "Summary description for {EQA_EW_SYSTEM_EXECUTION}."
	date: "$Date$"
	revision: "$Revision$"

class
	EQA_EW_SYSTEM_EXECUTION

create
	make

feature {NONE} -- Intialization

	make (a_prog: STRING; a_args: LINKED_LIST [STRING]; a_execute_cmd, a_dir, a_inf, a_outf, a_savef: STRING)
			-- Start a new process to execute `prog' with
			-- arguments `args' using execution command
			-- `execute_cmd' in directory `dir'.
			-- `inf' is the input file to be fed into the
			-- new process (void to set up pipe).
			-- `outf' is the file where new process is
			-- write its output (void to set up pipe).
			-- Write all output from the new process to
			-- file `savef'.
		require
			program_not_void: a_prog /= Void;
			arguments_not_void: a_args /= Void;
			directory_not_void: a_dir /= Void;
			save_name_not_void: a_savef /= Void;
		local
--			real_args: LINKED_LIST [STRING];
		do
--			create real_args.make;
--			real_args.extend (execute_cmd);
--			real_args.extend (dir);
--			real_args.extend (prog);
--			real_args.finish;
--			real_args.merge_right (args);
--			process_make (Shell_command, real_args, inf, outf, savef);
		end

feature -- Query

	next_execution_result: EQA_EW_EXECUTION_RESULT
			-- Next execution result
		local
--			time_to_stop: BOOLEAN
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
--			end;
--			if end_of_file then
--				terminate
--			end
		end

note
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
