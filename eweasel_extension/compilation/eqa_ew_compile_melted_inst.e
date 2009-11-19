note
	description: "[
					Summary description for {EQA_EW_COMPILE_MELTED_INST}.
					
					For old version, pleaase check {EW_COMPILE_MELTED_INST}
																					]"
	date: "$Date$"
	revision: "$Revision$"

class
	EQA_EW_COMPILE_MELTED_INST

inherit
	EQA_EW_START_COMPILE_INST

create
	make
	
feature -- Query

	compilation_options: LIST [STRING]
			-- <Precursor>
		once
			create {ARRAYED_LIST [STRING]} Result.make (1)
			Result.extend ("-verbose")
			Result.extend ("-melt")
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
