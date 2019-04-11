require 'rubygems'
require 'mqtt'

class MQTT_Helper

  def self.publish_bmw_data(mileage)
    # Publish example
    MQTT::Client.connect(ENV["MQTT_URI"]) do |c|
      topic = ENV["MQTT_TOPIC"]
      payload = "{\"mileage_km\": " + mileage + "}"
      c.publish(topic, payload, retain=false)
    end

  end

end