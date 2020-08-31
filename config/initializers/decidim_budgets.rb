# frozen_string_literal: true

require "budgets_workflow_random"
require "budgets_workflow_pam2020"
Decidim::Budgets.workflows[:random] = BudgetsWorkflowRandom
Decidim::Budgets.workflows[:pam2020] = BudgetsWorkflowPam2020
