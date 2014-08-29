class PageView < Sequel::Model

  def self.repopulate_with_random_dataset
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

    start_date = 2.months.ago
    end_date = Time.now

    random_date_generator = lambda { start_date + rand * (end_date - start_date) }

    self.truncate

    db.transaction do
      10000.times do
        self.create(
          url: available_urls.sample,
          referrer: available_referrers.sample,
          created_at: random_date_generator.call,
          hash: ''
        )
      end
    end

  end
  
end
