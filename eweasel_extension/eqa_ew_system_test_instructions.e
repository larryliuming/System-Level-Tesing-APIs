note
	description: "[
					New eweasel test instructions base on Testing library
					Should be used as client (do not inherit this class)
					
					For old version instructions, please check {EW_EQA_TEST_CONTROL_INSTRUCTIONS}
																								]"
	date: "$Date$"
	revision: "$Revision$"

class
	EQA_EW_SYSTEM_TEST_INSTRUCTIONS

create
	make

feature {NONE} -- Initialization

	make (a_system_test: EQA_EW_SYSTEM_TEST_SET)
			-- Creation method
		require
			not_void: attached a_system_test
		do
			test_set := a_system_test
		ensure
			set: test_set = a_system_test
		end

feature -- Command

	copy_raw (a_source_file, a_dest_directory, a_dest_file: STRING)
			--	Copy the file named <source-file> from the source directory
			--	$SOURCE to the <dest-directory> under the name <dest-file>.
			--	The destination directory is created if it does not exist.  No
			--	substitution is done on the lines of <source-file>.
		require
			not_void: attached a_source_file
			not_void: attached a_dest_directory
			not_void: attached a_dest_file
		local
			l_inst: EQA_EW_COPY_RAW_INST
		do
			create l_inst.make (a_source_file, a_dest_directory, a_dest_file, test_set)
			l_inst.execute
		end

	copy_sub (a_source_file, a_dest_directory, a_dest_file: STRING)
			--	Similar to `copy_raw' except that occurrences of a
			--	substitution variable, such as $NAME, are replaced by the
			--	value given to NAME in the last define, define_file or
			--	define_directory instruction which set it (or are left as
			--	$NAME if NAME has not been defined).
		require
			not_void: a_source_file /= Void
			not_void: a_dest_directory /= Void
			not_void: a_dest_file /= Void
		local
			l_inst: EQA_EW_COPY_SUB_INST
		do
			create l_inst.make (a_source_file, a_dest_directory, a_dest_file, test_set)
			l_inst.execute
		end

	compile_melted (a_output_filename: STRING)
			--	Run the Eiffel compiler in the test directory $TEST with the
			--	Ace file specified by the last `ace' instruction.  Since the
			--	Ace file is always assumed to be in the test directory, it
			--	must have previously been copied into this directory.

			--	Compile_melted does not request freezing of the system

			--	The optional <output-file-name> specifies
			--	the name of the file in the output directory $OUTPUT into
			--	which output from this compilation will be written, so that it
			--	can potentially be compared with a known correct output file.
			--	If <output-file-name> is omitted, compilation results are
			--	written to a file with an unadvertised but obvious name (which
			--	could possibly change) in the output directory.
		local
			l_inst: EQA_EW_COMPILE_MELTED_INST
		do
			create l_inst.make (test_set, a_output_filename)
			l_inst.execute
		end

	compile_result (a_result: STRING)
			--Check that the compilation result from the last
			--compile_melted, compile_frozen, compile_final or
			--resume_compile instruction matches <result>.  If it does not,
			--then the test has failed.  If the result matches <result>,
			--continue processing with the next test instruction.  To
			--specify no class for <class> below, use NONE (which matches
			--only if the compiler does not report the error in a particular
			--class).  <result> can be:

			--	syntax_error  { <class> <line-number> ";" ... }+
			--		
			--		Matches if compiler reported a syntax error on each
			--		of the indicated classes at the given line numbers,
			--		in the order indicated.
			--		If <line-number> is omitted, then matches if
			--		compiler reported a syntax error on class
			--		<class>, regardless of position.  To specify
			--		no class (which means "syntax error on the Ace
			--		file"), use NONE.

			--	validity_error { <class> <validity-code-list> ";" ...}+
			--		
			--		Matches if compiler reported the indicated
			--		validity errors in the named classes in the
			--		order listed.  This validity code list is a
			--		white space separated list of validity codes
			--		from "Eiffel: The Language".

			--	validity_warning { <class> <validity-code-list> ";" ...}+
			--		
			--		Matches if compiler reported the indicated
			--		validity errors in the named classes in the
			--		order listed.  This validity code list is a
			--		white space separated list of validity codes
			--		from "Eiffel: The Language".  This is
			--		identical to validity_error, except that
			--		the compilation is expected to complete
			--		for validity_warning whereas it is expected
			--		to be paused for validity_error.

			--	ok

			--		Matches if compiler did not report any syntax
			--		or validity errors and no system failure or
			--		run-time panic occurred and the system was
			--		successfully recompiled.
		require
			not_void: a_result /= Void
		local
			l_inst: EQA_EW_COMPILE_RESULT_INST
		do
			create l_inst
			l_inst.execute (test_set)
		end

feature {NONE} -- Implementation

	test_set: EQA_EW_SYSTEM_TEST_SET
			-- Test set that current managed

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
