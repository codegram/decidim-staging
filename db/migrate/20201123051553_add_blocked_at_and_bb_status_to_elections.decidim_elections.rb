# frozen_string_literal: true
# This migration comes from decidim_elections (originally 20201026163334)

class AddBlockedAtAndBbStatusToElections < ActiveRecord::Migration[5.2]
  def change
    add_column :decidim_elections_elections, :blocked_at, :datetime
    add_column :decidim_elections_elections, :bb_status, :string
  end
end
