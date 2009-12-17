note
	description: "[
					Define the substitution variable <name> to have the value			
					<value>.  If <value> contains white space characters, it must
					be enclosed in double quotes.  Substitution of variable values
					for names is triggered by the '$' character, when substitution
					is being done.  For example, $ABC will be replaced by the last
					value defined for variable ABC.  Case is significant and by
					convention substitution variables are normally given names
					which are all uppercase.  The name starts with the first
					character after the '$' and ends with the first non-identifier
					character (alphanumeric or underline) or end of line.
					Parentheses may be used to set a substitution variable off
					from the surrouding text (e.g., the substitution variable name
					in "$(ABC)D" is ABC, not ABCD).  If the named variable has not
					been defined, it is left as is during substitution (in the
					example above it would remain $(ABC)).  To get a $ character,
					use $$.  Substitution is always done when reading the lines of
					a test suite control file, test control file or test catalog.
					Substitution is done on the lines of a copied file when
					`copy_sub' is used, but not when `copy_raw' is used.
					 See
				 	"http://svn.origo.ethz.ch/viewvc/eiffelstudio/trunk/eweasel/doc/eweasel.doc?annotate=HEAD"
				 	for more information
																											]"
	legal: "See notice at end of class."
	status: "See notice at end of class."
	keywords: "Eiffel test"
	date: "$Date: 2009-06-04 08:11:49 +0800 (四, 04  6月 2009) $"
	revision: "$Revision: 79073 $"

class EQA_EW_DEFINE_INST

inherit
	EQA_EW_TEST_INSTRUCTION

create
	make

feature {NONE} -- Initialization

	make (a_arguments: STRING)
			-- Creation method
		require
			not_void: attached a_arguments and then not a_arguments.is_empty
		do
			inst_initialize (a_arguments)
		end

	inst_initialize (a_line: STRING)
			-- Initialize instruction from `a_line'.  Set
			-- `init_ok' to indicate whether
			-- initialization was successful.
		local
			args: LIST [STRING]
			count, pos: INTEGER
		do
			args := string_util.broken_into_words (a_line)
			count := args.count
			if count < 2 then
				failure_explanation := "argument count must be at least 2"
				init_ok := False
			elseif args.first.item (1) = {EQA_EW_SUBSTITUTION_CONST}.Substitute_char then
				create failure_explanation.make (0)
				failure_explanation.append ("variable being defined cannot start with ")
				failure_explanation.extend ({EQA_EW_SUBSTITUTION_CONST}.Substitute_char)
				init_ok := False
			elseif count = 2 then
				variable := args.i_th (1)
				value := args.i_th (2)
				init_ok := True
			else
				pos :=  string_util.first_white_position (a_line)
				variable := a_line.substring (1, pos - 1)
				value := a_line.substring (pos, a_line.count)
				value.left_adjust
				value.right_adjust
				init_ok := True
			end
			if init_ok then
				if value.item (1) = {EQA_EW_SUBSTITUTION_CONST}.Quote_char and
				   value.item (value.count) = {EQA_EW_SUBSTITUTION_CONST}.Quote_char then
					value.remove (value.count)
					value.remove (1)
				elseif value.item (1) = {EQA_EW_SUBSTITUTION_CONST}.Quote_char or
				   value.item (value.count) = {EQA_EW_SUBSTITUTION_CONST}.Quote_char then
					failure_explanation := "value must be quoted on both ends or on neither end"
					init_ok := False
				end
			end
			if init_ok then
--				init_environment.define (variable, value)
			end
		end

feature -- Command

	execute (a_test: EQA_EW_SYSTEM_TEST_SET)
			-- Execute `Current' as one of the
			-- instructions of `a_test'.  Always successful.
		do
			a_test.environment.put (value, variable)
		end

feature -- Query

	init_ok: BOOLEAN
			-- Was last call to `initialize' successful?

	execute_ok: BOOLEAN = True
			-- Calls to `execute' are always successful.

feature {NONE}

	variable: STRING
			-- Name of environment value

	value: STRING
			-- Value to be given to environment value

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