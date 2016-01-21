require 'rails_helper'
require 'ups'
require 'usps'

RSpec.describe ShipmentsController, type: :controller do
  describe "get #rates" do
    before :each do 
      shipment = {
        shipment: {
          origin: {
            country: "USA",  
            state: "WA", 
            city: "Seattle",
            zip: "98121"
          },
          destination: {
            street: "Ada Street", 
            state: "WA", 
            city: "Seattle", 
            zip: 98112
          },
          packages: {
            weight: 10,
            height: 5,
            length: 5,
            width: 5
          }
        }
      }

      @json = shipment.to_json
    end

    it "gets the page succesfully" do 
      get :rates, json_data: @json
      expect(response).to be_successful
      expect(response.response_code).to eq 200
    end

    it "returns JSON" do 
      get :rates, json_data: @json
      expect(response.header['Content-Type']).to include 'application/json'
    end

  end
end
