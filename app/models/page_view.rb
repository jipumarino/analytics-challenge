class PageView < Sequel::Model

  PageView.plugin :timestamps

  def before_validation
    calcluate_hash_value
    super
  end

  def self.top_urls
    select_group{ [Sequel.as(date(created_at), date), url] }.
    select_append{ Sequel.as(count(id), visits) }.
    where { created_at > 4.days.ago.to_date }
  end

  def calcluate_hash_value
    values = self.values.slice(:id, :url, :referrer, :created_at).reject{|_,v| v.nil?}
    self.hash = Digest::MD5.hexdigest(values.to_s)
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
          created_at: random_date_generator.call
        )
      end
    end

  end
  
end
