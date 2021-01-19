# frozen_string_literal: true
# This migration comes from decidim_elections (originally 20210114100749)

class AddPublishedAtToDecidimVotingsVotings < ActiveRecord::Migration[5.2]
  def change
    add_column :decidim_votings_votings, :published_at, :datetime
  end
end
