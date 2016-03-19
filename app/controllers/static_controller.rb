class StaticController < ApplicationController
  layout "frontpage"

  def homepage
    @text = "#{rand(10000)}"
  end
end
