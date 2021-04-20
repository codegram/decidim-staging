# frozen_string_literal: true
# This migration comes from decidim_elections (originally 20210330102348)

class RemoveVotesCountFromAnswer < ActiveRecord::Migration[5.2]
  def change
    remove_column :decidim_elections_answers, :votes_count, :integer
  end
end
