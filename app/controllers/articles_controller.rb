class ArticlesController < ApplicationController
  before_action :admin_required
  def new
    @article = Article.new
  end
end
