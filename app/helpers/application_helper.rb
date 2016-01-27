module ApplicationHelper
  include SimpleFormRansackHelper

  def destroy_button(object,confirmation="")
    link_to raw("<i class=\"fa fa-trash-o\"></i>"), object, :method => :delete,
      :class => %w{btn btn-sm btn-outline btn-danger}, :"data-confirm" => confirmation
  end

  def active?(url)
    if URI.parse(request_uri).path == URI.parse(url).path
      "active"
    else
      ""
    end
  end

  def acronym(short,long)
    raw("<acronym title='#{long}'>#{short}</acronym>")
  end
end
