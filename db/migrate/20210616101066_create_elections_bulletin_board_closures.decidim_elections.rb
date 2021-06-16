# frozen_string_literal: true
# This migration comes from decidim_elections (originally 20210412144740)

class CreateElectionsBulletinBoardClosures < ActiveRecord::Migration[5.2]
  def change
    create_table :decidim_elections_bulletin_board_closures do |t|
      t.belongs_to :decidim_elections_election,
                   null: false,
                   index: false

      t.timestamps
    end
  end
end
