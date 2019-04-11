# bmw2mqtt
Scrape mileage of your BMW from the the Connected Drive website and publish it to your MQTT server.

## Dependencies
* Ruby
* Firefox running
* Mozilla Geckodriver installed: 
```brew install geckodriver```


## Usage
* clone repo
* Install ruby dependencies:
```bundle intstall```
* Add your Credentials for BMW Connected Drive and MQTT:
```cp .env.default .env``` and fill your credentials in .env file
* run script:
```bundle exec dotenv ruby bmw2mqtt.rb```

## Credentials needed
Fill ```.env``` file with your CD credentials and MQTT URL + topic
```
BMW_CD_USER=email@example.com
BMW_CD_PASSWORD=xyz
BMW_VIN=XX012345
MQTT_URI=mqtt://user:pass@mqttserver.com
MQTT_TOPIC=mybmw
```

## Next steps
* add support for Chrome
* add other values from CD portal (fuel,...)
* remove ```sleep```
