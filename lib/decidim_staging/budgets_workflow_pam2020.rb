# frozen_string_literal: true

module DecidimStaging
  # Specific Workflow for Barcelona's 2020 PAM

  # !todo: fix to budget resources
  class BudgetsWorkflowPam2020 < Decidim::Budgets::Workflows::Base
    PAM2020AUTHORIZATIONHANDLER = 'dummy_census_authorization_handler'

    # The budget component in the user's scope is highlighted.
    def highlighted?(component)
      return unless user_scope_component && !voted?(user_scope_component)

      component == user_scope_component
    end

    # Can vote in the budget component in the user's scope
    # and in an extra component out of its scope
    def vote_allowed?(component, consider_progress = true)
      return true if component == user_scope_component

      components_with_order = voted
      components_with_order += progress if consider_progress

      (components_with_order - [user_scope_component, component]).empty?
    end

    # The user can change of mind and change the vote on these budget components
    #
    # Returns Array.
    def discardable
      (voted + progress) - [user_scope_component]
    end

    # The user can vote on maximum 2 components
    #
    # Returns Boolean.
    def limit_reached?
      (voted + progress).count < 3
    end

    private

    # Returns Object (Authorization).
    def user_authorization
      @user_authorization ||= Decidim::Authorization.find_by(
        name: PAM2020AUTHORIZATIONHANDLER,
        user: user
      )
    end

    # The budget component the user can and should vote on
    #
    # Returns Object (Component).
    def user_scope_component
      return unless user_authorization_scope

      @user_scope_component ||= budgets.each do |component|
        return component if component.scope == user_authorization_scope
      end
    end

    # The user's scope from the verifcation
    #
    # Returns Object (Scope).
    def user_authorization_scope
      return unless user_authorization

      # @user_authorization_scope ||= Decidim::Scope.find_by(
      # id: user_authorization.metadata["scope_id"])

      @user_authorization_scope ||= Decidim::Scope.find_by(
        "name->>'ca' = '#{user_authorization.metadata['scope']}'"
      )
    end
  end
end
