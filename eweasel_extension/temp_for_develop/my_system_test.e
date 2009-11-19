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
		local
			l_info: EQA_EVALUATION_INFO
		do
			create l_info

--			environment.*set
			initial_environment (environment, "attach004")
		end

feature -- Test

	new_test_attached004
			-- New version of test attach004
		local
			l_output_path: EQA_SYSTEM_PATH
			l_processor: EQA_EW_OUTPUT_PROCESSOR
		do
			create l_output_path.make_empty

			--Must use full path since current user's system environment virables not work
			environment.put ("/usr/local/Eiffel65/studio/spec/linux-x86/bin/ec", "EQA_EXECUTABLE") -- How to get {EQA_SYSTEM_EXECUTION}.executable_env ?
--			environment.put ("geant", "EQA_EXECUTABLE") -- How to get {EQA_SYSTEM_EXECUTION}.executable_env ?

	--		environment.system ("ec") -- This feature is used for running ad-hoc executables

			l_output_path.extend ("attach004")
			prepare_system (l_output_path)

			create l_processor.make (Current)
			current_execution.set_output_processor (l_processor)
			current_execution.set_error_processor (l_processor)

			environment.set_target_directory ("/home/larryliuming/eweasel/spec/linux-x86/bin")

			environment.set_source_directory ("/home/larryliuming/eweasel/")

			run_system (<<>>)
		end

	new_test_attached004_1
			-- New version of test attach004
		do
--			test_setup.setup_one_test_case ("object-test-with-local-use-failure", "attach004", "tcf pass object_test attached_types ")
--			test_name ("object-test-with-local-use-failure")
--			test_description ("Ensures the locally scoped object test variable cannot be used in the test")
			i.copy_raw ("test.e", "$CLUSTER", "test.e")

			i.copy_sub ("Ace", "$TEST", "Ace")
			i.compile_melted (Void)
			i.compile_result ("validity_error TEST VEEN")

--			test_end
		end

feature {NONE} -- Implementation

	i: EQA_EW_SYSTEM_TEST_INSTRUCTIONS
			-- All new instructions
		once
			create Result.make (Current)
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
