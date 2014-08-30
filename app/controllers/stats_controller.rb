class StatsController < ApplicationController
  def top_urls
    top_urls = PageView.top_urls.to_a
    grouped_by_date = top_urls.group_by{|v| v[:date].to_s}
    data = grouped_by_date.map do |key, values|
      [
        key,
        values.map{|v| { url: v[:url], visits: v[:visits] } }
      ]
    end
    render json: Hash[data]
  end

  def top_referrers
  end
end
