# frozen_string_literal: true
# This migration comes from decidim_elections (originally 20210120164634)

class AddPromotedToVoting < ActiveRecord::Migration[5.2]
  def change
    add_column :decidim_votings_votings, :promoted, :boolean, default: false, index: true
  end
end
