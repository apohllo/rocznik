namespace :articles do
  desc "TODO"
  task order_existing_articles: :environment do
    first_issue = Article.all.order(:issue_id).first.issue_id
    last_issue = Article.all.order(:issue_id).last.issue_id
    (first_issue..last_issue).each do |issue|
      articles = Article.all.where("issue_id = ?", issue)
      positions = articles.map(&:issue_position)
      if (positions.sum == positions.length)
        i = 0
        articles.each do |article|
          i = i + 1
          article.update_column(:issue_position, i)
          article.save
        end
      end
    end
  end
end
