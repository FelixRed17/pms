class CreateMagicLinks < ActiveRecord::Migration[8.1]
  def change
    create_table :magic_links do |t|
      t.string :token_digest, null: false
      t.string :purpose, null: false

      t.string :resource_type, null: false
      t.bigint :resource_id, null: false

      t.string :recipient_identifier
      t.datetime :expires_at, null: false
      t.datetime :used_at
      t.datetime :revoked_at
      t.datetime :accessed_at

      t.timestamps
    end

    add_index :magic_links, :token_digest, unique: true
    add_index :magic_links, :purpose
    add_index :magic_links, [:resource_type, :resource_id]
    add_index :magic_links, [:purpose, :resource_type, :resource_id], name: "index_magic_links_on_purpose_and_resource"
  end
end
