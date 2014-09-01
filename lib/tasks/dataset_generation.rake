namespace :dataset_generation do

  desc "Dummy dataset generation for Page Views"
  task generate_page_views: :environment do
    available_urls = %w(
      http://apple.com
      https://apple.com
      https://www.apple.com
      http://developer.apple.com
      http://en.wikipedia.org
      http://opensource.org
    )

    available_referrers = %w(
      http://apple.com
      https://apple.com
      https://www.apple.com
      http://developer.apple.com
    ) + [nil]

    start_date = 15.days.ago
    end_date = Time.now

    random_date_generator = lambda { start_date + rand * (end_date - start_date) }

    PageView.truncate

    PageView.db.transaction do
      10000.times do
        PageView.create(
          url: available_urls.sample,
          referrer: available_referrers.sample,
          created_at: random_date_generator.call
        )
      end
    end

  end

end
