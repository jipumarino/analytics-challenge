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

  def self.top_urls_for_day(date = Date.today, top_limit = 10)
    select_group(:url).
    select_append{ Sequel.as(count(id), visits) }.
    where(created_at: date..date+1).
    reverse_order(:visits).
    limit(top_limit)
  end

  def calcluate_hash_value
    values = self.values.slice(:id, :url, :referrer, :created_at).reject{|_,v| v.nil?}
    self.hash = Digest::MD5.hexdigest(values.to_s)
  end

end
