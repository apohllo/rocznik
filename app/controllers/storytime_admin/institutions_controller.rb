module StorytimeAdmin
  class InstitutionsController < StorytimeAdmin::ApplicationController
    # Set active navigation link
    set_tab :admin, :institutions

    private
    ##########################################
    ### Customize permitted_params
    ##########################################
    # def permitted_params
    #   params.require(model_sym).permit(permitted_attributes.map(&:to_sym))
    # end

    ##########################################
    ### Add attributes here to exclude them
    ### from permitted_params
    ##########################################
    # def permitted_params_blacklist
    #   ["id", "created_at", "updated_at"]
    # end

    ##########################################
    ### Add attributes here to use the default
    ### form but exclude additional attributes
    ##########################################
    # def form_blacklist
    #   ["id", "created_at", "updated_at"]
    # end

    def index_attr
      ["name", "acronym", "country_name"]
    end
  end
end
