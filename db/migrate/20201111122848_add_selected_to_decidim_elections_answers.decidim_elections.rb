# frozen_string_literal: true
# This migration comes from decidim_elections (originally 20201028135614)

class AddSelectedToDecidimElectionsAnswers < ActiveRecord::Migration[5.2]
  def change
    add_column :decidim_elections_answers, :selected, :boolean, null: false, default: false
  end
end
