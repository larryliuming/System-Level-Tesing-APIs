note
	description: "Summary description for {EWEASEL_OUTPUT_PROCESSOR}."
	date: "$Date$"
	revision: "$Revision$"

class
	EQA_EW_OUTPUT_PROCESSOR

inherit
	EQA_SYSTEM_OUTPUT_PROCESSOR
		redefine
			on_new_character,
			on_new_line
		end

create
	make

feature {NONE} -- Initializatin

	make (a_compilation_result: EQA_EW_EIFFEL_COMPILATION_RESULT)
			-- Creation method
		require
			not_void: attached a_compilation_result
		do
			initialize_buffer
			compilation_result := a_compilation_result
		ensure
			set: compilation_result = a_compilation_result
		end

feature {NONE} -- Implementation

	on_new_character (a_character: CHARACTER_8)
			-- <Precursor>
		do
			print ("%N " + generating_type.out + " on_new_character " + a_character.out)
		end

	on_new_line
			-- <Precursor>
		do
			print ("%N " + generating_type.out + " on_new_line " + buffer)

		end

	compilation_result: EQA_EW_EIFFEL_COMPILATION_RESULT
			-- Compilation result

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