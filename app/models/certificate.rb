class Certificate
  def generate_certificate(article)
    certificate= Prawn::Document.new 
    certificate.font(Rails.root.join("fonts", "DejaVuSans.ttf")) do
      if not article.authors.empty? 
        article.authors.each do |author|
          certificate.move_down 200
          certificate.font_size(32) do
            certificate.text "Zaświadczenie o przyjęciu do druku", align: :center
          end  
          certificate.move_down 100
          certificate.font_size(18) do            
            certificate.text "Artykuł '#{article.title}', " +
            "którego autorem jest #{author.full_name} " +
            "został przyjęty do druku w Roczniku Kognitywistycznym"+ 
            " w numerze #{article.issue_title}.", align: :center
          end
          certificate.move_down 200
          certificate.font_size(18) do
            long_space= " "
            30.times do long_space=long_space+" " end
            dots="."
            30.times do dots=dots+"." end
            certificate.text "#{Date.today}" + long_space+dots
            certificate.text "Data wystawienia"+long_space+ "Podpis"
          end
          if author != article.authors[-1]
            certificate.start_new_page
          end  
        end
      end
    end
    return certificate   
  end  
  
end
