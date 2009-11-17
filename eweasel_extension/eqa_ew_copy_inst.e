note
	description: "[
					New version of copy instruction
					
					For old version, please check {EW_COPY_INST}
																						]"
	date: "$Date$"
	revision: "$Revision$"

class
	EQA_EW_COPY_INST

feature -- Access

	execute (test: EQA_EW_SYSTEM_TEST)
			-- Execute `Current' as one of the
			-- instructions of `test'.
			-- Set `execute_ok' to indicate whether successful.
		local
--			src_name, dest_name: STRING;
--			src, dir, dest: like new_file;
--			before_date, after_date: INTEGER
--			orig_date, final_date: INTEGER

--			l_factory: EW_EQA_TEST_FACTORY
		do
--			create l_factory
--			dest_directory := l_factory.replace_environments (test.environment, dest_directory)
--			source_file := l_factory.replace_environments (test.environment, source_file)

--			execute_ok := False;
--			if use_source_environment_variable then
--				src_name := os.full_file_name (test.environment.value (Source_dir_name), source_file);
--			else
--				src_name := source_file
--			end
--			dest_name := os.full_file_name (dest_directory, dest_file);
--			src := new_file (src_name)
--			ensure_dir_exists (dest_directory);
--			dir := new_file (dest_directory)
--			if (src.exists and then src.is_plain) and
--			   (dir.exists and then dir.is_directory) then
--				dest := new_file (dest_name)
--				if dest.exists then
--					orig_date := dest.date
--				else
--					orig_date := 0
--				end
--				if is_fast then
--					copy_file (src, test.environment, dest);
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
--			end

		end

feature {NONE} -- Implementation

note
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
