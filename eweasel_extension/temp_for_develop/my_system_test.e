note
	description: "New version of test attach004"
	date: "$Date$"
	revision: "$Revision$"

class
	MY_SYSTEM_TEST

inherit
	EQA_EW_SYSTEM_TEST_SET
		redefine
			on_prepare
		end

feature -- Command

	on_prepare
			-- <Precursor>
		do
		end

feature -- Test

	new_test_attached004_1
			-- New version of test attach004
		do
			init_env (environment, "attach004")
			copy_raw ("test.e", "$CLUSTER", "test.e")

			copy_sub ("Ace", "$TEST", "Ace")
			compile_melted (Void)
			compile_result ("validity_error TEST VEEN")
		end

	test_agent004 is
			-- Test agent004
		do
			init_env (environment, "agent004")
			copy_sub ("Ace", "$TEST", "Ace")
			copy_raw ("test.e", "$CLUSTER", "test.e")
			copy_raw ("test1.e", "$CLUSTER", "test1.e")
			compile_melted (Void)
			compile_result ("ok")
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
