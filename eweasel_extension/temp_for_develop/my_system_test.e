note
	description: "[
					New version of eweasel tests
					
					This class only valid for new eweasel development
																		]"
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

	new_test_attached004
			-- New version of test attach004
		do
			init_env (environment, "attach004")
			copy_raw ("test.e", "$CLUSTER", "test.e")

			copy_sub ("Ace", "$TEST", "Ace")
			compile_melted (Void)
			compile_result ("validity_error TEST VEEN")
		end

	new_test_agent004 is
			-- New version of test agent004
		do
			init_env (environment, "agent004")
			copy_sub ("Ace", "$TEST", "Ace")
			copy_raw ("test.e", "$CLUSTER", "test.e")
			copy_raw ("test1.e", "$CLUSTER", "test1.e")
			compile_melted (Void)
			compile_result ("ok")
		end

	new_test_attach001 is
			-- Test attach001
		do
--			test_setup.setup_one_test_case ("object-test-semantics", "attach001", "tcf pass execution object_test expanded attached_types ")
--			test_name ("object-test-semantics")
--			test_description ("Object test should succeed and fail as expected.")
			init_env (environment, "attach001")
			copy_raw ("e.e", "$CLUSTER", "e.e")
			copy_raw ("test.e", "$CLUSTER", "test.e")
			copy_raw ("x.e", "$CLUSTER", "x.e")
			copy_sub ("Ace", "$TEST", "Ace")
			compile_melted (Void)
			compile_result ("ok")
			execute_work ("NONE", "exec_output_m", Void)
			execute_result ("ok")
			compare ("exec_output_m", "output")
			compile_frozen ("")
			compile_result ("ok")
			c_compile_work ("")
			c_compile_result ("ok")
			execute_work ("NONE", "exec_output_w", Void)
			execute_result ("ok")
			compare ("exec_output_w", "output")
			compile_final ("")
			compile_result ("ok")
			c_compile_final (Void)
			c_compile_result ("ok")
			execute_final ("NONE", "exec_output_f", Void)
			execute_result ("ok")
			compare ("exec_output_f", "output")
--			test_end
		end

	new_test_attach023 is
			-- Test attach023
		do
--			test_setup.setup_one_test_case ("attached-wrong-initialization", "attach023", "tcf pass attached_types ")
--			test_name ("attached-wrong-initialization")
--			test_description ("An empty routine returing `like Current' without creating its result automaticall call `default_create' even if it is not an attached type or if `default_create' is not a valid creation procedure.")
			init_env (environment, "attach023")

			copy_raw ("test.e", "$CLUSTER", "test.e")
			copy_sub ("Ace", "$TEST", "Ace")
			compile_melted (Void)
			compile_result ("ok")
			execute_work ("NONE", "exec_output_m", Void)
			execute_result ("ok")
			compare ("exec_output_m", "output")
			compile_frozen ("")
			compile_result ("ok")
			c_compile_work ("")
			c_compile_result ("ok")
			execute_work ("NONE", "exec_output_w", Void)
			execute_result ("ok")
			compare ("exec_output_w", "output")
			compile_final ("")
			compile_result ("ok")
			c_compile_final (Void)
			c_compile_result ("ok")
			execute_final ("NONE", "exec_output_f", Void)
			execute_result ("ok")
			compare ("exec_output_f", "output")
--			test_end
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
