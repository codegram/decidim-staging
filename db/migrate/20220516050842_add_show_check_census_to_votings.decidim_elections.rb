# frozen_string_literal: true
# This migration comes from decidim_elections (originally 20220424121541)

class AddShowCheckCensusToVotings < ActiveRecord::Migration[6.1]
  def change
    add_column :decidim_votings_votings, :show_check_census, :boolean, default: true
  end
end
