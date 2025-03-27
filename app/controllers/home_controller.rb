class HomeController < ApplicationController
  def index
    authorize :home
  end
end
