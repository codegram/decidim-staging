# frozen_string_literal: true
# This migration comes from decidim_elections (originally 20210402102215)

class AddBallotStyleToDecidimVotingsCensusData < ActiveRecord::Migration[5.2]
  def change
    add_reference :decidim_votings_census_data, :decidim_votings_ballot_style, foreign_key: true, index: { name: "decidim_votings_census_data_on_ballot_style_id" }, null: true
  end
end
