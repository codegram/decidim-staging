# frozen_string_literal: true
# This migration comes from decidim_elections (originally 20210422124826)

class AddVerifiableResultsToDecidimElectionsElection < ActiveRecord::Migration[6.0]
  def change
    add_column :decidim_elections_elections, :verifiable_results_file_url, :string
    add_column :decidim_elections_elections, :verifiable_results_file_hash, :string
  end
end
