class PageView < Sequel::Model

  def self.top_urls
    select_group{ [Sequel.as(date(created_at), date), url] }.
    select_append{ Sequel.as(count(id), visits) }.
    where { date(created_at) > date(Sequel.date_sub(now(0), days: 5))}
  end

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
