class HomeController < ApplicationController
  def index
    @activities = ActivityLog.all.order('id DESC').first(100)
  end
end
