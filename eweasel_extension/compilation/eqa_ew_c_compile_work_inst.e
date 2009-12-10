note
	description: "[
					Compile the C files generated by a `compile_melted' or
					`compile_frozen' instruction.  Note that `compile_melted' can
					result in freezing if there are external routines.  The
					optional <output-file-name> specifies the name of the file in
					the output directory $OUTPUT into which output from this
					compilation will be written, so that it can potentially be
					compared with a known correct output file.  If
					<output-file-name> is omitted, compilation results are written
					to a file with an unadvertised but obvious name (which could
					possibly change) in the output directory.
																								]"
	legal: "See notice at end of class."
	status: "See notice at end of class."
	keywords: "Eiffel test"
	date: "$Date: 2009-06-04 08:11:49 +0800 (四, 04  6月 2009) $"
	revision: "$Revision: 79073 $"

class EQA_EW_C_COMPILE_WORK_INST

inherit
	EQA_EW_C_COMPILE_INST

create
	make

feature {NONE} -- Implementation

	compilation_dir_name: STRING
			-- Name of directory where compilation is to be done
		once
			Result := {EQA_EW_PREDEFINED_VARIABLES}.Work_execution_dir_name
		end;

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
