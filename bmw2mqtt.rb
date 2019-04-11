#!/usr/bin/ruby
require "selenium-webdriver"
require "./mqtt_helper"

def get_bmw_data

  bmw_cd_user = ENV["BMW_CD_USER"]
  bmw_cd_password = ENV["BMW_CD_PASSWORD"]
  bmw_vin = ENV["BMW_VIN"].chars.last(7).join # we need only the last 7 characters

  driver = Selenium::WebDriver.for :firefox
  driver.manage.timeouts.implicit_wait = 30

  driver.get "https://www.bmw-connecteddrive.de/app/index.html#/portal"

  wait_until(10) {driver.find_element(:xpath, ".//language-selection-loader/language-selection/div/div[2]/div/div[2]/div/div[1]/div/div[2]/a/div/span[2]/span").displayed?}
  language = driver.find_element(:xpath, ".//language-selection-loader/language-selection/div/div[2]/div/div[2]/div/div[1]/div/div[2]/a/div/span[2]/span")
  language.click

  sleep(3)
  driver.find_element(:link, "Login").click

  sleep(3)
  driver.find_element(:id, "inputEmail").clear
  driver.find_element(:id, "inputEmail").send_keys bmw_cd_user
  driver.find_element(:id, "inputPassword").clear
  driver.find_element(:id, "inputPassword").send_keys bmw_cd_password
  driver.find_element(:xpath, "(.//*[normalize-space(text()) and normalize-space(.)='Passwort'])[1]/following::button[1]").click
  driver.find_element(:id, "vehicle-chooser-remote-cockpit").click

  sleep(6)
  driver.find_element(:xpath, "(.//*[normalize-space(text()) and normalize-space(.)='VIN: " + bmw_vin + "'])[1]/following::span[2]").click
  kilometerstand = driver.find_element(:xpath, "(.//*[normalize-space(text()) and normalize-space(.)='VIN: " + bmw_vin + "'])[1]/following::span[2]").text
  #km_reichweite = driver.find_element(:xpath, "*/cockpit-status-loader/cockpit-status/div/vehicle-stage-container/vehicle-stage/div/bmw-stage/div/div[1]/div[1]/bmw-streamline/div/div/div[2]/div/span[1]").text.sub! 'km Reichweite', ''

  driver.find_element(:xpath, "(.//*[normalize-space(text()) and normalize-space(.)='Mein Konto'])[2]/following::span[4]").click
  driver.find_element(:xpath, "(.//*[normalize-space(text()) and normalize-space(.)='Abbrechen'])[1]/following::button[1]").click
  driver.quit

  MQTT_Helper.publish_bmw_data(kilometerstand)
end

# Method will either interrupt waiting when condition is truthy,
# or it will throw Timeout error after N seconds
def wait_until(timeout = DEFAULT_WAIT_TIME)
  Timeout.timeout(timeout) do
    sleep(0.1) until value = yield
    value
  end
end

get_bmw_data