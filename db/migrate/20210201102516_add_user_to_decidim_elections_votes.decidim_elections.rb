# frozen_string_literal: true
# This migration comes from decidim_elections (originally 20210114111850)

class AddUserToDecidimElectionsVotes < ActiveRecord::Migration[5.2]
  def change
    add_reference :decidim_elections_votes, :decidim_user, null: false
  end
end
