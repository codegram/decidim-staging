# frozen_string_literal: true
# This migration comes from decidim_elections (originally 20200918153813)

class CreateDecidimElectionsTrusteesParticipatorySpaces < ActiveRecord::Migration[5.2]
  def change
    create_table :decidim_elections_trustees_participatory_spaces do |t|
      t.references :participatory_space, polymorphic: true, index: { name: "index_elections_trustees_spaces_on_space_type_and_id" }
      t.references :decidim_elections_trustee, null: false, index: { name: "index_elections_trustees_spaces_on_elections_trustee_id" }
      t.boolean :considered, null: false, default: true

      t.timestamps
    end
  end
end
