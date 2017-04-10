module ApplicationHelper
  include SimpleFormRansackHelper

  def destroy_button(object,confirmation="")
    link_to raw("<i class=\"fa fa-trash-o\"></i>"), object, :method => :delete,
      :class => %w{btn btn-outline btn-danger}, :"data-confirm" => confirmation
  end

  def edit_button(object,path,title="")
    link_to raw("<i class=\"fa fa-pencil-square-o\"></i>"), path, class: %w{btn btn-outline btn-default},
      title: title
  end

  def icon_to(klass,path,options={})
    link_to(raw("<i class='fa #{klass}'></i>"), path, {class: %w{btn btn-outline btn-default}}.merge(options))
  end

  def active?(url)
    return "" if url.nil?
    logger.info([url, request_uri])
    logger.info([path_id(url), path_id(request_uri)])
    if path_id(request_uri) == path_id(url)
      "active"
    else
      ""
    end
  end

  def acronym(short,long)
    raw("<acronym title='#{long}'>#{short}</acronym>")
  end

  def reset_filters(f)
    f.button :button, raw('&#10007;'), type: 'reset', class: 'btn btn-danger btn-sm', onclick: 'reload(); return false',
      title: "Wyczyść filtry"
  end

  def set_title(title = "")
    @site_title = !title.empty? ? title + " - " + "Rocznik Kognitywistyczny" : "Rocznik Kognitywistyczny"
  end

  private
  def path_id(url)
    URI.parse(url).path.gsub(%r{^/+},"").gsub(%r{/+$},"")
  end
end
