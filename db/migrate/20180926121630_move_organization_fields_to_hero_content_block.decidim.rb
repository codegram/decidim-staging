# frozen_string_literal: true
# This migration comes from decidim (originally 20180810092428)

class MoveOrganizationFieldsToHeroContentBlock < ActiveRecord::Migration[5.2]
  def change
    remove_column :decidim_organizations, :welcome_text
    remove_column :decidim_organizations, :homepage_image
  end
end
