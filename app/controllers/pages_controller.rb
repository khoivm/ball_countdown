class PagesController < ApplicationController
  protect_from_forgery with: :exception

  def index
    @names = %w(elliot helen daniel kristy)

  end
end
