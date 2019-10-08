class Orchestration
    attr_accessor :query, :conversation_state, :location, :partner, :response

    def initialize(params, partner)
        @query = params["fm-question"] # string, query from the STT engine of UneeQ
        @conversation_state = params["fm-conversation"].blank? ? nil : params["fm-conversation"] # Maintain conversation state between utterances
        @location = params["fm-custom-data"].blank? ? {} : JSON.parse(params["fm-custom-data"])
        @partner = partner # string, the name of the partner company we reach out to
        @response = nil
    end

    def orchestrate
        case @partner
        when "Arria"
            Arria.new.query_arria(@query)
        else 
            return nil
        end
    end
end
