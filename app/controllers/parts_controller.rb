class PartsController < ApplicationController
  def index
    @parts = Part.all
  end
end
