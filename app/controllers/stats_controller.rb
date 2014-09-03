class StatsController < ApplicationController
  def top_urls
    render json: PageView.top_urls
  end

  def top_referrers
    render json: PageView.top_referrers
  end
end
