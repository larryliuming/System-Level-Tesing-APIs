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

--create
--	make

--feature {NONE} -- Initialization

--	make (a_system_test: EQA_EW_SYSTEM_TEST_SET)
--			-- Creation method
--		require
--			not_void: attached a_system_test
--		do
--			test_set := a_system_test
--		ensure
--			set: test_set = a_system_test
--		end

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
			l_inst.execute (test_set)
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
			l_inst.execute (test_set)
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
			create l_inst.make (test_set, a_output_filename) 	--FIXME: pass `test_set' two times?
			l_inst.execute (test_set)							--FIXME: pass `test_set' two times?
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
			create l_inst.make (a_result)
			l_inst.execute (test_set)
		end

	execute_work (a_input_file: STRING; a_output_file: STRING; a_args: STRING)
			--	Execute the workbench version of the system named by the last
			--	`system' instruction (or `test' if no previous system
			--	instruction).  The system will get its input from `a_input_file'
			--	in the source directory $SOURCE and will place its output in
			--	`a_output-file' in the output directory $OUTPUT.  If present,
			--	the optional `a_args' will be passed to the system as command
			--	line arguments.  To specify no input file or no output file,
			--	use the name NONE.
		local
			l_inst: EQA_EW_EXECUTE_WORK_INST
		do
			create l_inst
			l_inst.execute (test_set)
		end

	Execute_result (a_result: STRING)
			--	Check that the result from the last execute_work or
			--	execute_final instruction matches <result>.  If it does not,
			--	then the test has failed and the rest of the test instructions
			--	are skipped.  If the result matches <result>, continue
			--	processing with the next test instruction.  <result> can be:

			--	ok

			--	Matches if no exception trace or run-time
			--	panic occurred and there were no error
			--	messages of any kind.

			--	failed

			--	Matches if system did not complete normally
			--	(did not exit with 0 status) and output includes
			--	a "system execution failed" string

			--	failed_silently

			--	Matches if system did not complete normally
			--	(did not exit with 0 status) but output does not
			--	include a "system execution failed" string

			--	completed_but_failed

			--	Matches if system completed normally
			--	(exited with 0 status) but output includes
			--	a "system execution failed" string
		require
			not_void: a_result /= Void
		local
			l_inst: EQA_EW_EXECUTE_RESULT_INST
		do
			create l_inst.make (a_result)
--			l_inst := test_command_table.item (Execute_result_keyword)
--			init_command (l_inst, "execute_result", a_result)
			l_inst.execute (test_set)
		end

	Compare (a_output_filename, a_correct_output_filename: STRING)
			--	Compare the file <output-file> in the output directory $OUTPUT
			--	with the file <correct-output-file> in the source directory
			--	$SOURCE.  If they are not identical, then the test has failed
			--	and the rest of the test instructions are skipped.  If they
			--	are identical, continue processing with the next test
			--	instruction.
		require
			not_void: a_output_filename /= Void
			not_void: a_correct_output_filename /= Void
		local
			l_inst: EQA_EW_COMPARE_INST
		do
			create l_inst.make (a_output_filename + " " + a_correct_output_filename)

			l_inst.execute (test_set)
		end

	Compile_frozen (a_output_filename: STRING)
			-- Similar to `Compile_melted'
			-- Compile_frozen requests freezing of the system
		local
			l_inst: EQA_EW_COMPILE_FROZEN_INST
--			l_temp: STRING
		do
			create l_inst.make (test_set, a_output_filename)

			l_inst.execute (test_set)
--			l_inst := test_command_table.item (Compile_frozen_keyword)
--			if a_output_filename = Void then
--				l_temp := ""
--			else
--				l_temp := a_output_filename
--			end
--			init_command (l_inst, "compile_frozen", l_temp)
--			execute_inst (l_inst)
		end

	C_compile_work (a_output_filename: STRING)
			--	Compile the C files generated by a `compile_melted' or
			--	`compile_frozen' instruction.  Note that `compile_melted' can
			--	result in freezing if there are external routines.  The
			--	optional <output-file-name> specifies the name of the file in
			--	the output directory $OUTPUT into which output from this
			--	compilation will be written, so that it can potentially be
			--	compared with a known correct output file.  If
			--	<output-file-name> is omitted, compilation results are written
			--	to a file with an unadvertised but obvious name (which could
			--	possibly change) in the output directory.
		local
			l_inst: EQA_EW_C_COMPILE_WORK_INST
--			l_temp: STRING
		do
			create l_inst.make (a_output_filename)
			l_inst.execute (test_set)
--			l_inst := test_command_table.item (C_compile_work_keyword)
--			if a_output_filename = Void then
--				l_temp := ""
--			else
--				l_temp := a_output_filename
--			end
--			init_command (l_inst, "c_compile_work", l_temp)

--			execute_inst (l_inst)
		end

	C_compile_result (a_result: STRING)
			--	Check that the result from the last c_compile_work or
			--	c_compile_final instruction matches <result>.  If it does not,
			--	then the test has failed and the rest of the test instructions
			--	are skipped.  If the result matches <result>, continue
			--	processing with the next test instruction.  <result> can be:

			--		ok
			--			Matches if compiler successfully compiled all
			--			C files and linked an executable.
		require
			not_void: a_result /= Void
		local
--			l_inst: EW_TEST_INSTRUCTION
		do
--			l_inst := test_command_table.item (C_compile_result_keyword)
--			init_command (l_inst, "c_compile_result", a_result)
--			execute_inst (l_inst)
		end

	Compile_final (a_output_filename: STRING)
			-- Similar to `Compile_melted'
			-- Compile_final requests finalizing of the system with assertions discarded
		local
			l_inst: EQA_EW_COMPILE_FINAL_INST
--			l_temp: STRING
		do
			create l_inst.make (test_set, a_output_filename)
			l_inst.execute (test_set)
--			l_inst := test_command_table.item (Compile_final_keyword)
--			if a_output_filename = Void then
--				l_temp := ""
--			else
--				l_temp := a_output_filename
--			end
--			init_command (l_inst, "compile_final", l_temp)
--			execute_inst (l_inst)
		end

	C_compile_final (a_output_filename: STRING)
			--	Just like `c_compile_work', except that it compiles the C
			--	files generated by a `compile_final' instruction.
		local
--			l_inst: EW_TEST_INSTRUCTION
--			l_temp: STRING
		do
--			l_inst := test_command_table.item (C_compile_final_keyword)
--			if a_output_filename = Void then
--				l_temp := ""
--			else
--				l_temp := a_output_filename
--			end
--			init_command (l_inst, "c_compile_final", l_temp)

--			execute_inst (l_inst)
		end

	Execute_final (a_input_file: STRING; a_output_file: STRING; a_args: STRING)
			--	Similar to `execute_work', except that the final version of
			--	the system is executed.
		require
			not_void: a_input_file /= Void
			not_void: a_output_file /= Void
		local
--			l_inst: EW_TEST_INSTRUCTION
--			l_temp: STRING
--			l_factory: EW_EQA_TEST_FACTORY
		do
--			l_inst := test_command_table.item (Execute_final_keyword)
--			l_temp := a_input_file + " " + a_output_file
--			if a_args /= Void then
--				l_temp := l_temp + " " + a_args
--			end

--			create l_factory
--			l_temp := l_factory.environment.substitute (l_temp)

--			init_command (l_inst, "execute_final", l_temp)
--			execute_inst (l_inst)
		end

feature {NONE} -- Implementation

	test_set: EQA_EW_SYSTEM_TEST_SET
			-- Test set that current managed
		do
			Result ?= Current
		ensure
			not_void: Result /= Void
		end

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
