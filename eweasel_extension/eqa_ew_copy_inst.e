note
	description: "[
					New version of copy instruction
					
					For old version, please check {EW_COPY_INST}
																						]"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	EQA_EW_COPY_INST

feature {NONE} -- Initialization

	make (a_source_file, a_dest_directory, a_dest_file: STRING)
			-- Initialize with arguments
		require
			not_void: a_source_file /= Void
			not_void: a_dest_directory /= Void
			not_void: a_dest_file /= Void
		do
			source_file := a_source_file
			dest_directory := a_dest_directory
			dest_file := a_dest_file
		end

feature -- Query

	substitute: BOOLEAN
			-- Should each line of copied file have
			-- environment variable substitution applied to it?
		deferred
		end

feature -- Commannd

	execute (a_test: EQA_EW_SYSTEM_TEST_SET)
			-- Execute `Current' as one of the
			-- instructions of `test'.
			-- Set `execute_ok' to indicate whether successful.
		local
			l_src_name, l_dest_name: EQA_SYSTEM_PATH
			l_src, l_dir, l_dest: like new_file
--			before_date, after_date: INTEGER
--			orig_date, final_date: INTEGER

--			l_factory: EW_EQA_TEST_FACTORY
			l_file_system: EQA_FILE_SYSTEM
		do
--			create l_factory
			dest_directory := a_test.environment.substitute_recursive (dest_directory)
			source_file := a_test.environment.substitute_recursive (source_file)

--			execute_ok := False;
--			if use_source_environment_variable then
			create l_src_name.make (<<a_test.environment.value ({EQA_EW_PREDEFINED_VARIABLES}.Source_dir_name),source_file>>)
--				l_src_name := os.full_file_name (, );	
--			else
--				src_name := source_file
--			end
			create l_dest_name.make (<<dest_directory, dest_file>>)

			create l_file_system.make (a_test.environment)

			l_src := new_file (l_src_name.as_string)
			ensure_dir_exists (dest_directory)
			l_dir := new_file (dest_directory)

			if (l_src.exists and then l_src.is_plain) and
			   (l_dir.exists and then l_dir.is_directory) then
				l_dest := new_file (l_dest_name.as_string)
--				if dest.exists then
--					orig_date := dest.date
--				else
--					orig_date := 0
--				end
--				if is_fast then
--					copy_file (src, test.environment, dest);
					l_file_system.copy_file (l_src, a_test.environment, l_dest, substitute)
--					if orig_date /= 0 then
--						dest.set_date (orig_date + 1)
--					end
--				else

--					before_date := os.current_time_in_seconds
--					from
--					until
--						not test.copy_wait_required
--					loop
--						os.sleep_milliseconds (100)
--					end;
--					after_date := os.current_time_in_seconds

--					copy_file (src, test.environment, dest);

--					final_date := dest.date

--					if final_date <= orig_date then
--						-- Work around possible Linux bug
--						if after_date <= orig_date then
--							output.append_error ("ERROR: After date " + after_date.out + " not greater than original date " + orig_date.out, True)
--						else
--							dest.set_date (after_date)
--							final_date := dest.date
--							if final_date /= after_date then
--								output.append_error ("ERROR: failed to set dest modification date to " + after_date.out, True)
--							end
--						end
--					end

--					check_dates (test.e_compile_start_time, orig_date, final_date, before_date, after_date, dest_name)

--					test.unset_copy_wait;
--				end
--				execute_ok := True;
--			elseif not src.exists then
--				failure_explanation := "source file not found";
--			elseif not src.is_plain then
--				failure_explanation := "source file not a plain file";
--			elseif not dir.exists then
--				failure_explanation := "destination directory not found";
--			elseif not dir.is_directory then
--				failure_explanation := "destination directory not a directory";
			end

		end

feature {NONE} -- Implementation

	new_file (a_file_name: STRING): FILE
			-- Create an instance of FILE.
		require
			a_file_name_not_void: a_file_name /= Void
		deferred
		ensure
			new_file_not_void: Result /= Void
		end

	ensure_dir_exists (a_dir_name: STRING)
			-- Try to ensure that directory `dir_name' exists
			-- (it is not guaranteed to exist at exit).
		require
			name_not_void: a_dir_name /= Void
		local
			l_dir: DIRECTORY
			l_tried: BOOLEAN
		do
			if not l_tried then
				create l_dir.make (a_dir_name)
				if not l_dir.exists then
					l_dir.create_dir
				end
			end
		rescue
			l_tried := True
			retry
		end

	dest_directory: STRING
			-- Name of destination directory

	dest_file: STRING
			-- Name of destination file

	source_file: STRING
			-- Name of source file (always in source directory)

;note
	copyright: "Copyright (c) 1984-2009, Eiffel Software and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	licensing_options: "http://www.eiffel.com/licensing"
	copying: "[
			This file is part of Eiffel Software's Eiffel Development Environment.
			
			Eiffel Software's Eiffel Development Environment is free
			software; you can redistribute it and/or modify it under
			the terms of the GNU General Public License as published
			by the Free Software Foundation, version 2 of the License
			(available at the URL listed under "license" above).
			
			Eiffel Software's Eiffel Development Environment is
			distributed in the hope that it will be useful, but
			WITHOUT ANY WARRANTY; without even the implied warranty
			of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
			See the GNU General Public License for more details.
			
			You should have received a copy of the GNU General Public
			License along with Eiffel Software's Eiffel Development
			Environment; if not, write to the Free Software Foundation,
			Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA
		]"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"
end
