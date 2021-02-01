# frozen_string_literal: true
# This migration comes from decidim_elections (originally 20201216091123)

class AddNameToTrustees < ActiveRecord::Migration[5.2]
  def change
    add_column :decidim_elections_trustees, :name, :string, null: true, unique: true
  end
end
