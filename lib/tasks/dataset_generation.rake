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


    def random_date
      start_date = 15.days.ago
      end_date = Time.now
      start_date + rand * (end_date - start_date)
    end

    def random_segment
      (0...(rand(15)+1)).map{ ('a'..'z').to_a.sample }.join
    end

    def random_host
      ((0...(rand(3)+1)).map{ random_segment } << %w(com org net edu gov).sample).join(".")
    end

    def random_path
      ((0...(rand(5)+1)).map{ random_segment }).join("/")
    end

    def random_url
      "http" + ["s", ""].sample + "://" + random_host + "/" + random_path
    end

    30.times do
      available_urls << random_url
      available_referrers << random_url
    end

    PageView.truncate

    PageView.db.transaction do
      10000.times do
        PageView.create(
          url: available_urls.sample,
          referrer: available_referrers.sample,
          created_at: random_date
        )
      end
    end

  end

end
