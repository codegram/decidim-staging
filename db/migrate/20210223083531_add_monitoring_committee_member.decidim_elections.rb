# frozen_string_literal: true
# This migration comes from decidim_elections (originally 20210216074707)

class AddMonitoringCommitteeMember < ActiveRecord::Migration[5.2]
  def change
    create_table :decidim_votings_monitoring_committee_members do |t|
      t.references :decidim_votings_voting, index: { name: "decidim_votings_votings_monitoring_committee_members" }
      t.references :decidim_user, index: { name: "decidim_users_votings_monitoring_committee_members" }

      t.timestamps
    end
  end
end
