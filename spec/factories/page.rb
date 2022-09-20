# frozen_string_literal: true

FactoryBot.define do
  factory :page, class: 'Bigcommerce::V3::Page' do
    channel_id { 1 }
    name { Faker::Lorem.sentence }
    meta_title { Faker::Lorem.sentence }
    type { 'page' }
    is_visible { true }
    meta_keywords { Faker::Lorem.words(number: 7).join(', ') }
    meta_description { Faker::Lorem.sentence }
    is_homepage { false }
    is_customers_only { false }
    search_keywords { Faker::Lorem.words(number: 7).join(', ') }
    url { "/#{Faker::Internet.slug}" }

    traits_for_enum :type, %w[page raw contact_form feed link blog]

    trait :contact_form do
      type { 'contact_form' }
      email { Faker::Internet.email }
    end
  end
end
