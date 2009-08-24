note
	description: "[
		Stateless object containing information about the current test evaluation.
	]"
	author: ""
	date: "$Date: 2009-08-05 16:47:29 +0800 (Wed, 05 Aug 2009) $"
	revision: "$Revision: 80111 $"

class
	EQA_EVALUATION_INFO

feature -- Access

	test_name: READABLE_STRING_8
			-- Name of test currently being executed
		do
			if attached test_name_cell.item as l_name then
				Result := l_name
			else
				Result := default_test_name
			end
		ensure
			result_attached: Result /= Void
		end

	working_directory: READABLE_STRING_32
			-- Name of testing directory currently being used
		do
			if attached working_directory_cell.item as l_dir then
				Result := l_dir
			else
				Result := default_working_directory
			end
		ensure
			result_attached: Result /= Void
		end

feature {NONE} -- Access

	test_name_cell: CELL [detachable READABLE_STRING_8]
			-- Cell containing name of test currently being tested
		once
			create Result.put (Void)
		ensure
			result_attached: Result /= Void
		end

	default_test_name: STRING = ""
			-- Default value for `test_name'

	working_directory_cell: CELL [detachable READABLE_STRING_32]
			-- Cell containg dir path of testing currently being used
		once
			create Result.put (Void)
		ensure
			reasult_attached: Result /= Void
		end

	default_working_directory: STRING_32
			-- Default value for `working_directory'
		do
			Result := create {STRING_32}.make_from_string (".")
		end

feature {EQA_TEST_EVALUATOR} -- Element change

	set_test_name (a_name: like test_name)
			-- Set `test_name' to given name.
			--
			-- `a_name': Name for test next test to be executed.
		require
			a_name_attached: a_name /= Void
		do
			test_name_cell.put (a_name)
		ensure
			test_name_set: test_name = a_name
		end

	set_working_directory (a_dir: like working_directory)
			-- Set `working_directory' to `a_dir'
			--
			-- `a_dir': Path for testing where next testing to be executed
		require
			a_dir_attached: a_dir /= Void
		do
			working_directory_cell.put (a_dir)
		ensure
			working_directory_set: working_directory = a_dir
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
