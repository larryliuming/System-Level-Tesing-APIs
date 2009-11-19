note
	description: "[
					Summary description for {EQA_EW_EIFFEL_COMPILATION_RESULT}.
					
					For old version, please check {EW_EIFFEL_COMPILATION_RESULT}
																							]"
	date: "$Date$"
	revision: "$Revision$"

class
	EQA_EW_EIFFEL_COMPILATION_RESULT

feature -- Command

	update (a_line: STRING)
			-- Update `Current' to reflect the presence of
			-- `a_line' as next line in compiler output.
		local
			l_s: SEQ_STRING
		do
			create l_s.make (a_line.count)
			l_s.append (a_line)
			if string_util.is_prefix ({EQA_EW_EIFFEL_COMPILER_CONSTANTS}.Pass_prefix, a_line) then
				l_s.start
				l_s.search_string_after ({EQA_EW_EIFFEL_COMPILER_CONSTANTS}.Pass_string, 0)
				if not l_s.after then
					in_error := False
				end
			elseif string_util.is_prefix ({EQA_EW_EIFFEL_COMPILER_CONSTANTS}.Syntax_error_prefix, a_line) then
				analyze_syntax_error (a_line)

			elseif string_util.is_prefix ({EQA_EW_EIFFEL_COMPILER_CONSTANTS}.Syntax_warning_prefix, a_line) then
				analyze_syntax_warning (a_line)
			elseif string_util.is_prefix ({EQA_EW_EIFFEL_COMPILER_CONSTANTS}.Validity_error_prefix, a_line) or
			       string_util.is_prefix ({EQA_EW_EIFFEL_COMPILER_CONSTANTS}.Validity_warning_prefix, a_line) then
				in_error := True
				analyze_validity_error (a_line)
			elseif string_util.is_prefix ({EQA_EW_EIFFEL_COMPILER_CONSTANTS}.Resume_prompt, a_line) then
				compilation_paused := True
			elseif string_util.is_prefix ({EQA_EW_EIFFEL_COMPILER_CONSTANTS}.Missing_precompile_prompt, a_line) then
				missing_precompile := True
				compilation_paused := True
			elseif string_util.is_prefix ({EQA_EW_EIFFEL_COMPILER_CONSTANTS}.Aborted_prefix, a_line) then
				compilation_aborted := True
			elseif string_util.is_prefix ({EQA_EW_EIFFEL_COMPILER_CONSTANTS}.Exception_prefix, a_line) then
				had_exception := True
				if exception_tag = Void then
					create exception_tag.make(0)
				end
				a_line.keep_tail(a_line.count - {EQA_EW_EIFFEL_COMPILER_CONSTANTS}.Exception_prefix.count)
				exception_tag.copy (a_line)
			elseif string_util.is_prefix ({EQA_EW_EIFFEL_COMPILER_CONSTANTS}.Exception_occurred_prefix, a_line) then
				had_exception := True
				if exception_tag = Void then
					create exception_tag.make(0)
				end
				if exception_tag.count = 0 then
					a_line.keep_tail (a_line.count - {EQA_EW_EIFFEL_COMPILER_CONSTANTS}.Exception_occurred_prefix.count)
					exception_tag.copy (a_line)
				end
			elseif string_util.is_prefix ({EQA_EW_EIFFEL_COMPILER_CONSTANTS}.Failure_prefix, a_line) then
				execution_failure := True
			elseif string_util.is_prefix ({EQA_EW_EIFFEL_COMPILER_CONSTANTS}.Illegal_inst_prefix, a_line) then
				illegal_instruction := True
			elseif string_util.is_prefix ({EQA_EW_EIFFEL_COMPILER_CONSTANTS}.Finished_prefix, a_line) then
				compilation_finished := True
			elseif in_error then
				analyze_error_line (a_line)
			end
			l_s.to_lower
			l_s.start
			l_s.search_string_after ({EQA_EW_EIFFEL_COMPILER_CONSTANTS}.Panic_string, 0)
			if not l_s.after then
				had_panic := True
			end
		end

feature {NONE} -- Syntax error implementation

	new_syntax_error (line: STRING): EQA_EW_EIFFEL_SYNTAX_ERROR
			-- Create a syntax error object
		require
			line_not_void: line /= Void
		local
			words: LIST [STRING]
			line_no, kind: STRING
			class_name: STRING
			count: INTEGER
		do
			words := string_util.broken_into_words (line)
			count := words.count
			if count >= 5 then
				line_no := words.i_th (5)
			end
			if count >= 7 then
				kind := words.i_th (7)
				kind.to_lower
				if equal (kind, "class") then
					if count >= 8 then
						class_name := words.i_th (8)
					else
						create class_name.make (0)
					end
				elseif equal (kind, "ace") then
					create class_name.make (0)
				elseif equal (kind, "cluster_properties") then
					create class_name.make (0)
					class_name.append ("_USE_FILE")
				else
					create class_name.make (0)
					class_name.append ("%"UNKNOWN%"")
				end
			else
				create class_name.make (0)
			end
			create Result.make (class_name)
			if string_util.is_integer (line_no) then
				Result.set_line_number (line_no.to_integer)
			end
		end

	new_syntax_warning (a_line: STRING): EQA_EW_EIFFEL_SYNTAX_ERROR
				-- Create a syntax warning object
		require
			line_not_void: a_line /= Void
		local
			l_words: LIST [STRING]
			l_line_no, l_kind: STRING
			l_class_name: STRING
			l_count: INTEGER
		do
			l_words := string_util.broken_into_words (a_line)
			l_count := l_words.count
			if l_count >= 6 then
				l_line_no := l_words.i_th (6)
			end
			if l_count >= 8 then
				l_kind := l_words.i_th (8)
				l_kind.to_lower
				if equal (l_kind, "class") then
					if l_count >= 9 then
						l_class_name := l_words.i_th (9)
					else
						create l_class_name.make (0)
					end
				elseif equal (l_kind, "ace") then
					create l_class_name.make (0)
				elseif equal (l_kind, "cluster_properties") then
					create l_class_name.make (0)
					l_class_name.append ("_USE_FILE")
				else
					create l_class_name.make (0)
					l_class_name.append ("%"UNKNOWN%"")
				end
			else
				create l_class_name.make (0)
			end
			create Result.make (l_class_name)
			if string_util.is_integer (l_line_no) then
				Result.set_line_number (l_line_no.to_integer)
			end
		end

	new_validity_error (a_line: STRING): EQA_EW_EIFFEL_VALIDITY_ERROR
			-- Create a validity error object
		require
			line_not_void: a_line /= Void
		local
			l_words: LIST [STRING]
			l_code: STRING
			l_class_name: STRING
		do
			l_words := string_util.broken_into_words (a_line)
			l_code := l_words.i_th (3)
			create l_class_name.make (0)
			create Result.make (l_class_name, l_code)
		end

	analyze_syntax_error (a_line: STRING)
			-- Analyze syntax error
		require
			line_not_void: a_line /= Void
		do
			add_syntax_error (new_syntax_error (a_line))
		end

	analyze_syntax_warning (a_line: STRING)
			-- Analyze syntax warning
		require
			line_not_void: a_line /= Void
		do
			add_syntax_error (new_syntax_warning (a_line))
		end

	analyze_validity_error (a_line: STRING)
			-- Analyze validity error
		require
			line_not_void: a_line /= Void
		do
			add_validity_error (new_validity_error (a_line))
		end

	add_syntax_error (a_err: EQA_EW_EIFFEL_SYNTAX_ERROR)
			-- Add syntax error
		require
			error_not_void: a_err /= Void
		do
			if syntax_errors = Void then
				create syntax_errors.make
			end
			syntax_errors.extend (a_err)
		end

	add_validity_error (a_err: EQA_EW_EIFFEL_VALIDITY_ERROR)
			-- Add validity error
		require
			error_not_void: a_err /= Void
		do
			if validity_errors = Void then
				create validity_errors.make
			end
			validity_errors.extend (a_err)
			last_validity_error := a_err
		end

	syntax_errors: SORTED_TWO_WAY_LIST [EQA_EW_EIFFEL_SYNTAX_ERROR]
			-- Syntax errors reported by compiler

	validity_errors: SORTED_TWO_WAY_LIST [EQA_EW_EIFFEL_VALIDITY_ERROR]
			-- Validity errors reported by compiler

	last_validity_error: EQA_EW_EIFFEL_VALIDITY_ERROR
			-- Last validity error being inserted

feature {NONE} -- Implementation

	analyze_error_line (a_line: STRING)
			-- Analyze error line
		require
			line_not_void: a_line /= Void
		local
			l_words: LIST [STRING]
			l_class_name: STRING
		do
			if string_util.is_prefix ({EQA_EW_EIFFEL_COMPILER_CONSTANTS}.Class_name_prefix, a_line) then
				l_words := string_util.broken_into_words (a_line)
				if l_words.count >= 2 then
					l_class_name := l_words.i_th (2)
					check
						last_validity_error_not_void: last_validity_error /= Void
					end
					last_validity_error.set_class_name (l_class_name)
				end
				in_error := False
			end
		end

	string_util: EQA_EW_STRING_UTILITIES
			-- String utilities
		once
			create Result
		end

	in_error: BOOLEAN
			-- Are we analyzing lines which are part of
			-- a syntax or validity error?

	had_exception: BOOLEAN
			-- Did an exception occur during compilation?

	compilation_paused: BOOLEAN
			-- Did compilation pause and await user input
			-- before resuming?

	compilation_aborted: BOOLEAN
			-- Was compilation aborted prematurely, usually
			-- due to an exception?

	missing_precompile: BOOLEAN
			-- Was a missing precompile detected during
			-- compilation?

	exception_tag: STRING
			-- Tag of exception which aborted compilation,
			-- if any

	execution_failure: BOOLEAN
			-- Did a system execution failure occur during
			-- compilation?

	illegal_instruction: BOOLEAN
			-- Was an illegal instruction executed
			-- during compilation?

	had_panic: BOOLEAN
			-- Did a panic occur during compilation?

	compilation_finished: BOOLEAN
			-- Did compilation finish normally?

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
