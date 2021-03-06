note
	description: "[
		Objects creating directories and files in a system test set environment.
	]"
	author: ""
	date: "$Date: 2009-08-05 16:47:29 +0800 (Wed, 05 Aug 2009) $"
	revision: "$Revision: 80111 $"

class
	EQA_FILE_SYSTEM

create
	make

feature {NONE} -- Initialization

	make (a_environment: like environment)
			-- Initialize `Current'.
			--
			-- `a_environment': Environment for current system test.
		require
			a_environment_attached: a_environment /= Void
		do
			environment := a_environment
		end

feature -- Access

	environment: EQA_SYSTEM_ENVIRONMENT
			-- Environment for current system test.

	last_created_directory: detachable DIRECTORY
			-- Directory last created through `create_directory_from_path'

	last_created_file: detachable PLAIN_TEXT_FILE
			-- File last created through `create_file_from_path'

feature -- Command

	delete_directory_tree (a_dir_name: STRING)
			-- Try to delete the directory tree rooted at
			-- `a_dir_name'.  Ignore any errors
		require
			directory_not_void: a_dir_name /= Void;
		local
			l_dir: DIRECTORY
			l_retried: BOOLEAN
		do
			if not l_retried then
				create l_dir.make (a_dir_name)
				l_dir.recursive_delete
			end
		rescue
			l_retried := True
			retry
		end

	delete_one_kind_of_files (a_dir_name: STRING; a_file_extension: STRING)
			-- Delete all files which extentions are `a_file_extension'
			-- found in directory `a_dir_name'
		require
			not_void: a_file_extension /= Void and then not a_file_extension.is_empty
		local
			l_dir: DIRECTORY
			l_dir_entries: ARRAYED_LIST [STRING]
			l_name: STRING
			l_len: INTEGER
			f: RAW_FILE
		do
			l_len := a_file_extension.count
			create l_dir.make (a_dir_name)
			l_dir_entries := l_dir.linear_representation;
			from
				l_dir_entries.start
			until
				l_dir_entries.after
			loop
				l_name := l_dir_entries.item.twin
				l_name.keep_tail (l_len)
				if l_name.is_equal (a_file_extension) then
					create f.make (full_file_name (a_dir_name, l_dir_entries.item))
					f.delete
				end
				l_dir_entries.forth
			end
		end

	copy_file (a_src: FILE; a_env: EQA_SYSTEM_ENVIRONMENT; a_dest: FILE; a_substitute: BOOLEAN)
			-- Append lines of file `a_src', with environment
			-- variables substituted according to `a_env' (but
			-- only if `substitute' is true) to
			-- file `a_dest'.
		require
			source_not_void: a_src /= Void
			destination_not_void: a_dest /= Void
			environment_not_void: a_env /= Void
			source_is_closed: a_src.is_closed
			destination_is_closed: a_dest.is_closed
		local
			l_line: STRING
		do
			from
				a_src.open_read
				a_dest.open_write
			until
				a_src.end_of_file
			loop
				a_src.read_line
				if a_substitute then
					l_line := a_env.substitute (a_src.last_string)
				else
					l_line := a_src.last_string
				end
				if not a_src.end_of_file then
					a_dest.put_string (l_line)
					a_dest.new_line
				elseif not l_line.is_empty then
					a_dest.put_string (l_line)
				end
			end;
			a_src.close
			a_dest.flush
			a_dest.close
		end

feature -- Query

	build_source_path (a_path: EQA_SYSTEM_PATH): STRING
			-- Build the actual path name relative to the source directory for given path.
			--
			-- `a_path': Path for which path name should be built
			-- `Result': Path name relative to source directory.
		require
			a_path_attached: a_path /= Void
		do
			Result := build_partial_path (a_path, source_directory, 0)
		ensure
			result_attached: Result /= Void
		end

	build_target_path (a_path: EQA_SYSTEM_PATH): STRING
			-- Build the actual path name relative to the target directory for given path.
			--
			-- `a_path': Path for which path name should be built
			-- `Result': Path name relative to target directory.
		require
			a_path_attached: a_path /= Void
		do
			Result := build_partial_path (a_path, target_directory, 0)
		ensure
			result_attached: Result /= Void
		end

	has_same_content_as_string (a_path: EQA_SYSTEM_PATH; a_string: READABLE_STRING_8): BOOLEAN
			-- Does target file for path have same content as given string?
			--
			-- `a_path': Path relative to `target_directory' of file
			-- `a_string': String to be compared with content of file
			-- `Result': True if file has same content as `a_string', False otherwise
			--
			-- Note: if file does not exists or is not readable an exception is raised.
		require
			a_path_attached: a_path /= Void
			a_path_not_empty: not a_path.is_empty
			a_string_attached: a_string /= Void
		local
			l_filename: like build_target_path
			l_file: FILE
			i, l_count: INTEGER
		do
			l_filename := build_target_path (a_path)
			create {PLAIN_TEXT_FILE} l_file.make (l_filename)
			assert ("file_exists", l_file.exists)
			assert ("file_readable", l_file.is_readable)
			l_file.open_read
			from
				i := 1
				l_count := a_string.count
				Result := True
				l_file.read_character
			until
				i > l_count or l_file.end_of_file or not Result
			loop
				Result := a_string.item (i) = l_file.last_character
				l_file.read_character
				i := i + 1
			end
			if Result then
				Result := i > l_count and l_file.end_of_file
			end
			l_file.close
		end

	has_same_content_as_path (a_first_path, a_second_path: EQA_SYSTEM_PATH): BOOLEAN
			-- Do target files for given paths have the same content?
			--
			-- `a_first': Relative path of first file.
			-- `a_second': Relative path of second file.
			-- `Result': True if both files existed and are readable and have identical content, False
			--           otherwise
			--
			-- Note: if files do not exist or are not readable an exception is raised.
		require
			a_first_path_attached: a_first_path /= Void
			a_first_path_not_empty: not a_first_path.is_empty
			a_second_path_attached: a_second_path /= Void
			a_second_path_not_empty: not a_second_path.is_empty
		local
			l_filename1, l_filename2: like build_target_path
			l_file1, l_file2: FILE
		do
			l_filename1 := build_target_path (a_first_path)
			l_filename2 := build_target_path (a_second_path)
			create {PLAIN_TEXT_FILE} l_file1.make (l_filename1)
			create {PLAIN_TEXT_FILE} l_file2.make (l_filename2)
			assert ("file1_exists", l_file1.exists)
			assert ("file2_exists", l_file2.exists)
			assert ("file1_readable", l_file1.readable)
			assert ("file2_readable", l_file2.readable)
			l_file1.open_read
			l_file2.open_read
			from
				l_file1.read_character
				l_file2.read_character
				Result := True
			until
				l_file1.end_of_file or l_file2.end_of_file or not Result
			loop
				Result := l_file1.last_character = l_file2.last_character
				l_file1.read_character
				l_file2.read_character
			end
			if Result then
				Result := l_file1.end_of_file and l_file2.end_of_file
			end
			l_file1.close
			l_file2.close
		end

	executable_file_exists (s: STRING): detachable STRING
			-- If file `s' does not exist or is not a file or
			-- is not executable, string describing the
			-- problem.  Void otherwise
		local
			f: RAW_FILE
			l_fname: STRING
		do
			if s /= Void then
				l_fname := s
			else
				l_fname := "(Void file name)"
			end
			create f.make (l_fname)
			if not f.exists then
				Result := "file " + l_fname + " not found"
			elseif not f.is_plain then
				Result := "file " + l_fname + " not a plain file"
			elseif not f.is_executable then
				Result := "file " + l_fname + " not executable"
			end
		end

feature {NONE} -- Query

	source_directory: READABLE_STRING_8
			-- Name of directory in which original testing directories are located.
		do
			Result := environment.source_directory
		end

	target_directory: READABLE_STRING_8
			-- Name of directory in which testing directories are created.
		do
			Result := environment.target_directory
		end

	build_partial_path (a_path: EQA_SYSTEM_PATH; a_prefix: READABLE_STRING_8; a_strip: INTEGER): DIRECTORY_NAME
			-- Build a partial path name relative to to a given directory.
			--
			-- `a_path': Path for which path name should be built
			-- `a_prefix': Absolute directory name to which `a_path' is relative.
			-- `a_strip': Numer of items at the end of `a_path' to be neglected.
			-- `Result': Path name relative to target directory.
		require
			a_path_attached: a_path /= Void
			a_prefix_attached: a_prefix /= Void
			a_strip_valid: a_strip >= 0 and a_strip <= a_path.count
		local
			i, l_count: INTEGER
		do
			create Result.make_from_string (a_prefix)
			Result.extend (environment.test_suffix)
			from
				l_count := a_path.count - a_strip
				i := 1
			until
				i > l_count
			loop
				Result.extend (a_path.item (i))
				i := i + 1
			end
		ensure
			result_attached: Result /= Void
		end

feature -- Basic operations

	create_directory_from_path (a_path: EQA_SYSTEM_PATH)
			-- Recursively create target directory from path and store {DIRECTORY} instance in
			-- `last_created_directory'.
			--
			-- `a_path': Path representing path name for target directory.
		require
			a_path_attached: a_path /= Void
		do
			last_created_directory := Void
			create_directory_from_partial_path (a_path, 0)
		ensure
			last_created_directory_attached: last_created_directory /= Void
			last_created_directory_has_correct_path: attached last_created_directory as l_dir
				and then l_dir.name.same_string (build_target_path (a_path))
			last_created_directory_exists: attached last_created_directory as l_dir2
				and then l_dir2.exists
		end

	create_file_from_path (a_path: EQA_SYSTEM_PATH)
			-- Create target file from path recursively and store open writable {PLAIN_TEXT_FILE}
			-- instance in `last_crerated_file'. Also {DIRECTORY} instance of target directory in which new
			-- file is located will be stored in `last_created_directory'.
			--
			-- `a_path': Path representing path name for target file.
		require
			a_path_attached: a_path /= Void
			a_path_not_empty: not a_path.is_empty
		local
			l_file: PLAIN_TEXT_FILE
		do
			create_directory_from_partial_path (a_path, 1)
			create l_file.make (build_target_path (a_path))
			if (l_file.exists and then l_file.is_writable) or l_file.is_creatable then
				l_file.open_write
			elseif l_file.is_creatable then
				l_file.create_read_write
			end
			last_created_file := l_file
		ensure
			last_created_file_attached: last_created_file /= Void
			last_created_file_open_write: attached last_created_file as l_last_file and then
				l_last_file.is_open_write
			last_created_directory_attached: last_created_directory /= Void
			last_created_directory_has_correct_path: attached last_created_directory as l_dir
				and then l_dir.name.same_string (build_partial_path (a_path, target_directory, 1))
			last_created_directory_exists: attached last_created_directory as l_dir2
				and then l_dir2.exists
		end

feature {NONE} -- Implementation

	create_directory_from_partial_path (a_path: EQA_SYSTEM_PATH; a_strip: INTEGER)
			-- Recursively create target directory from partial path recursively and store {DIRECTORY}
			-- instance in `last_created_directory'.
			--
			-- `a_path': Path representing path name for target directory.
			-- `a_strip': Numer of items at the end of `a_path' to be neglected.
		require
			a_path_attached: a_path /= Void
			a_strip_valid: a_strip >= 0 and a_strip <= a_path.count
		local
			l_dirname: DIRECTORY_NAME
			l_directory: like last_created_directory
		do
			l_dirname := build_partial_path (a_path, target_directory, a_strip)

				-- Reuse any existing directory in `last_created_directory'
				--
				-- Note: setting `last_created_directory' Void in `create_directory_from_path' prevents reusing
				--       a directory instance used by a client.
			l_directory := last_created_directory
			if l_directory = Void then
				create l_directory.make (l_dirname)
				last_created_directory := l_directory
			else
				l_directory.make (l_dirname)
			end

			if not l_directory.exists then
				if a_strip = a_path.count then
					check_target_directory_existence
				else
					create_directory_from_partial_path (a_path, a_strip + 1)
				end

					-- `check_target_directory_existence' and `create_directory_from_partial_path' both alter the
					-- current directory name, so we have to reset it.
				l_directory.make (l_dirname)

				l_directory.create_dir
				assert ("target_directory_createable", l_directory.exists)
			end
		ensure
			last_created_directory_attached: last_created_directory /= Void
			last_created_directory_has_correct_path: attached last_created_directory as l_dir
				and then l_dir.name.same_string (build_partial_path (a_path, target_directory, a_strip))
			last_created_directory_exists: attached last_created_directory as l_dir2
				and then l_dir2.exists
		end

	check_target_directory_existence
			-- Check if `target_directory' exists, raise exception through `assert' if that is not the case.
		require
			last_created_directory_attached: last_created_directory /= Void
		local
			l_directory: like last_created_directory
		do
			l_directory := last_created_directory
			check l_directory /= Void end
			l_directory.make (target_directory)
			assert ("testing_directory_exists", l_directory.exists)
		ensure
			last_created_directory_attached: last_created_directory /= Void
			last_created_directory_has_correct_path: attached last_created_directory as l_dir
				and then l_dir.name.same_string (target_directory)
			last_created_directory_exists: attached last_created_directory as l_dir2
				and then l_dir2.exists
		end

	frozen assert (a_tag: STRING; a_condition: BOOLEAN)
			-- Assert `a_condition' using asserter from current test set.
		require
			a_tag_attached: a_tag /= Void
		do
			environment.test_set.assert (a_tag, a_condition)
		end

	full_file_name (a_dir_name, a_f_name: STRING): STRING
			-- Full name of file in directory `a_dir_name'
			-- with name `a_f_name'.
		require
			not_void: a_dir_name /= Void and then not a_dir_name.is_empty
			not_void: a_f_name /= Void and then not a_f_name.is_empty
		local
			l_os: OPERATING_ENVIRONMENT
		do
			create Result.make (a_dir_name.count + a_f_name.count + 1)
			if not a_dir_name.is_empty then
				Result.append (a_dir_name)
				create l_os
				if a_dir_name.item (a_dir_name.count) /= l_os.Directory_separator then
					Result.extend (l_os.Directory_separator)
				end
			end
			Result.append (a_f_name)
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
