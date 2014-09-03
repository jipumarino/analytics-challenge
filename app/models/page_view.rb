class PageView < Sequel::Model

  plugin :timestamps
  plugin :validation_helpers

  def validate
    super
    validates_presence [:url, :hash]
  end

  def before_validation
    calcluate_hash_value
    super
  end

  def self.top_urls
    select_group{ [Sequel.as(date(created_at), date), url] }.
    select_append{ Sequel.as(count(id), visits) }.
    where { created_at > 4.days.ago.to_date }
  end

  def self.top_referrers
    data = 4.downto(0).map do |d|
      date = d.days.ago.to_date
      [
        date.to_s,
        top_urls_for_day(date).to_a.map do |pv|
          {
            url: pv[:url],
            visits: pv[:visits],
            referrers: self.top_referrers_for_url_and_day(pv[:url], date).to_a.map(&:values)
          }
        end
      ]
    end

    return Hash[data]
  end

  def self.top_urls_for_day(date = Date.today, top_limit = 10)
    select_group(:url).
    select_append{ Sequel.as(count(id), visits) }.
    where(created_at: date..date+1).
    reverse_order(:visits).
    limit(top_limit)
  end

  def self.top_referrers_for_url_and_day(url, date = Date.today, top_limit = 5)
    select_group{ Sequel.as(referrer, 'url') }.
    select_append{ Sequel.as(count(id), visits) }.
    where(created_at: date..date+1).
    where(url: url).
    reverse_order(:visits).
    limit(top_limit)
  end

  def calcluate_hash_value
    values = self.values.slice(:id, :url, :referrer, :created_at).reject{|_,v| v.nil?}
    self.hash = Digest::MD5.hexdigest(values.to_s)
  end

end
