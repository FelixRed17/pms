require "minitest/autorun"

class MigrationIntegrityTest < Minitest::Test
  MIGRATION_GLOB = File.expand_path("../db/migrate/*.rb", __dir__)

  def test_migration_versions_are_unique
    versions = migration_entries.map { |entry| entry[:version] }

    assert_equal versions.uniq.sort, versions.sort, duplicate_message("version", versions)
  end

  def test_migration_class_names_are_unique
    class_names = migration_entries.map { |entry| entry[:class_name] }

    assert_equal class_names.uniq.sort, class_names.sort, duplicate_message("class", class_names)
  end

  private

  def migration_entries
    Dir[MIGRATION_GLOB].sort.map do |path|
      basename = File.basename(path, ".rb")
      version, inferred_name = basename.split("_", 2)
      contents = File.read(path)
      class_name = contents[/class\s+([A-Z]\w*)\s+<\s+ActiveRecord::Migration/, 1]

      {
        version:,
        inferred_name:,
        class_name: class_name || inferred_name.split("_").map(&:capitalize).join
      }
    end
  end

  def duplicate_message(type, values)
    duplicates = values.group_by(&:itself).select { |_value, occurrences| occurrences.size > 1 }.keys
    "Duplicate migration #{type}s found: #{duplicates.join(', ')}"
  end
end
