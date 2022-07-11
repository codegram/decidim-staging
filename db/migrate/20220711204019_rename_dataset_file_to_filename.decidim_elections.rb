# frozen_string_literal: true
# This migration comes from decidim_elections (originally 20220711112802)

class RenameDatasetFileToFilename < ActiveRecord::Migration[6.1]
  def change
    rename_column :decidim_votings_census_datasets, :file, :filename
  end
end
