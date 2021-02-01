# frozen_string_literal: true
# This migration comes from decidim_elections (originally 20210113113818)

class AddMessageIdToDecidimElectionsVotes < ActiveRecord::Migration[5.2]
  def change
    add_column :decidim_elections_votes, :message_id, :string, null: false
  end
end
