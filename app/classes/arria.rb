class Arria
    require 'base64'
    require 'openssl'
    require 'json'
  
    MORNINGSTAR_ENDPOINT="https://app.studio.arria.com:443/alite_content_generation_webapp/text/zQllOBR5YYn"
    AUSTRALIAN_ENDPOINT="https://app.studio.arria.com:443/alite_content_generation_webapp/text/ZXLYorgz9do"
    EXPENSE_ENDPOINT="https://app.studio.arria.com:443/alite_content_generation_webapp/text/egnKRMyvYx8"
    BUSINESS_ENDPOINT="https://app.studio.arria.com:443/alite_content_generation_webapp/text/kMd7rDZeZ5x"
    
  
    attr_accessor :arria_request_info, :location
  
    def initialize
      
    end
  
    def query_arria(query)
      query = query.downcase
      case query
      when "show morningstar data"
        begin
          response = query(query, MORNINGSTAR_ENDPOINT, Rails.application.credentials.morningstar_api_key)
          text = ActionView::Base.full_sanitizer.sanitize(response[0]["result"])
          create_json_to_send(text)
        rescue StandardError => e
          puts e
        end
      when "show australian data"
        begin
          response = query(query, AUSTRALIAN_ENDPOINT, Rails.application.credentials.australian_api_key)
          text = ActionView::Base.full_sanitizer.sanitize(response[0]["result"])
          create_json_to_send(text)
        rescue StandardError => e
          puts e
        end
      when "show expense data"
        begin
          response = query(query, EXPENSE_ENDPOINT, Rails.application.credentials.expense_api_key)
          text = ActionView::Base.full_sanitizer.sanitize(response[0]["result"])
          create_json_to_send(text)
        rescue StandardError => e
          puts e
        end
      when "show business data"
        begin
          response = query(query, BUSINESS_ENDPOINT, Rails.application.credentials.business_api_key)
          text = ActionView::Base.full_sanitizer.sanitize(response[0]["result"])
          create_json_to_send(text)
        rescue StandardError => e
          puts e
        end
      else
        return nil
      end
    end
  
    def generate_headers(api_key)
      headers = {
        "Authorization" => "Bearer #{api_key}",
        "Content-type" => "application/json;charset=UTF-8"
      }
    end

    def default_arria_payload
      {
        "type": "object",
        "properties": {
          "data": [{
              "id": "Primary",
              "type": "1d",
              "dataSet": []
          }],
          "options": {
              "nullValueBehaviour": "SHOW_IDENTIFIER",
              "contentOutputFormat": "TEXT",
              "contentLineEnding": "\n",
              "contentLineLength": 50,
              "templateFragment": {
                  "fragmentName": "Main"
              }
          }
        }
      }
    end
  
    def query(text_query, endpoint, api_key)
      body = default_arria_payload.to_json
      options = {
        headers: generate_headers(api_key),
        body: body
      }
      response = HTTParty.post(endpoint, options)
  
      begin
        # puts response.body
        return JSON.load(response.body)
      rescue
        return { "Error": response }
      end
    end
  
    def generate_json_string(data)
        JSON.generate(data)
    end
  
    def create_json_to_send(text, html = nil, expression = nil)
        answer_body = {
            "answer": text,
            "instructions": {
                "expressionEvent": [
                  expression
                ],
                "emotionalTone": [
                    {
                        "tone": "happiness", # desired emotion in lowerCamelCase
                        "value": 0.5, # number, intensity of the emotion to express between 0.0 and 1.0 
                        "start": 2, # number, in seconds from the beginning of the utterance to display the emotion
                        "duration": 4, # number, duration in seconds this emotion should apply
                        "additive": true, # boolean, whether the emotion should be added to existing emotions (true), or replace existing ones (false)
                        "default": true # boolean, whether this is the default emotion 
                    }
                ],
                "displayHtml": {
                    "html": ""
                }
            }
        }
  
        body = {
            "answer": generate_json_string(answer_body),         
            "matchedContext": "",
            "conversationPayload": "",
        }
        return body
    end
  end