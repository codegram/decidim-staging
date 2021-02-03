# frozen_string_literal: true
# This migration comes from decidim_elections (originally 20210129124956)

class CreateDecidimElectionsActions < ActiveRecord::Migration[5.2]
  def change
    create_table :decidim_elections_actions do |t|
      t.belongs_to :decidim_elections_election, null: false, index: { name: "index_elections_actions_on_decidim_elections_election_id" }
      t.integer :action, null: false
      t.string :message_id, null: false
      t.integer :status, null: false

      t.timestamps
    end
  end
end
