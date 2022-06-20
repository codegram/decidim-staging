# frozen_string_literal: true
# This migration comes from decidim_elections (originally 20220615102642)

class RemoveDescriptionFromElectionsQuestions < ActiveRecord::Migration[6.1]
  def change
    remove_column :decidim_elections_questions, :description, :jsonb
  end
end
