class AuthorController < ApplicationController
  def new
    @author = ArticleRevision.new
  end

  private
  def author_params
    params.require(:author).permit(:article, :comment, :accepted)
  end
end
