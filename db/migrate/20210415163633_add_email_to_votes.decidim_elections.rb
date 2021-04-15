# frozen_string_literal: true
# This migration comes from decidim_elections (originally 20210330183204)

class AddEmailToVotes < ActiveRecord::Migration[5.2]
  def change
    change_table :decidim_elections_votes, bulk: true do |t|
      t.string :email
      t.change :decidim_user_id, :bigint, null: true, index: true
    end
  end
end
