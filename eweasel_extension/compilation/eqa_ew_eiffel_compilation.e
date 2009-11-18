note
	description: "[
						Summary description for {EQA_EW_EIFFEL_COMPILATION}.
						
						For old version, please check {EW_EIFFEL_COMPILATION}
																						]"
	date: "$Date$"
	revision: "$Revision$"

class
	EQA_EW_EIFFEL_COMPILATION

create
	make
	
feature {NONE} -- Creation method

	make (a_cmd: STRING; a_args: LIST [STRING]; a_save: STRING)
			-- Start a new Eiffel compilation process to
			-- run command `a_cmd' with arguments `a_args'.
			-- Write all output from the new process to
			-- file `a_save'.
		require
			command_not_void: a_cmd /= Void
			arguments_not_void: a_args /= Void
			save_name_not_void: a_save /= Void
		do
--			process_make (cmd, args, Void, Void, save)
		ensure
--			input_file_available: input /= Void
--			output_file_available: output /= Void
		end

feature -- Query

	suspended: BOOLEAN
			-- Is process suspended awaiting user input?

	next_compile_result: EQA_EW_EIFFEL_COMPILATION_RESULT
			-- Next compile result
		local
			l_time_to_stop: BOOLEAN
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
--			if not Result.is_status_known then
--				-- Save raw compiler output so it can
--				-- be displayed
--				Result.set_raw_compiler_output (savefile_contents)
--			end
--			if end_of_file then
--				terminate
--			end
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
