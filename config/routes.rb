require "sidekiq/web"

Rails.application.routes.draw do
  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end

  mount Decidim::Core::Engine => "/"
  authenticate :user, lambda { |u| u.roles.include?("admin") } do
    mount Sidekiq::Web => "/sidekiq"
  end
end
