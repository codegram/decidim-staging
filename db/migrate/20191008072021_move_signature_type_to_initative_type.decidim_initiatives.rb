# frozen_string_literal: true
# This migration comes from decidim_initiatives (originally 20191002082220)

class MoveSignatureTypeToInitativeType < ActiveRecord::Migration[5.2]
  class InitiativesType < ApplicationRecord
    self.table_name = :decidim_initiatives_types
  end

  def change
    face_to_face_voting_allowed = true

    add_column :decidim_initiatives_types, :signature_type, :integer, null: false, default: 0

    InitiativesType.reset_column_information

    Decidim::Initiatives::InitiativesType.find_each do |type|
      type.signature_type = if type.online_signature_enabled && face_to_face_voting_allowed
                              :any
                            elsif type.online_signature_enabled && !face_to_face_voting_allowed
                              :online
                            else
                              :offline
                            end
      type.save!
    end

    remove_column :decidim_initiatives_types, :online_signature_enabled
  end
end
