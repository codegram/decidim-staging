# frozen_string_literal: true
# This migration comes from decidim (originally 20201006061208)

class AddDemographicsDataCollectionToDecidimOrganization < ActiveRecord::Migration[5.2]
  def change
    add_column :decidim_organizations, :demographics_data_collection, :boolean, default: false
  end
end
