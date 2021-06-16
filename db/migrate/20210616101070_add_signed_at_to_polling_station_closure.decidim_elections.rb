# frozen_string_literal: true
# This migration comes from decidim_elections (originally 20210426072845)

class AddSignedAtToPollingStationClosure < ActiveRecord::Migration[6.0]
  def change
    add_column :decidim_votings_polling_station_closures, :signed_at, :date
  end
end
