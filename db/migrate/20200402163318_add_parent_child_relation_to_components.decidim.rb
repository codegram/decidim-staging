# frozen_string_literal: true
# This migration comes from decidim (originally 20200401110737)

class AddParentChildRelationToComponents < ActiveRecord::Migration[5.2]
  def change
    add_reference :decidim_components, :parent, index: true
  end
end
