module ApplicationHelper
  def destroy_button(object,confirmation="")
    link_to raw("<i class=\"fa fa-trash-o\"></i>"), object, :method => :delete,
      :class => %w{btn btn-sm btn-outline btn-danger}, :"data-confirm" => confirmation
  end
end
