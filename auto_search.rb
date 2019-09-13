# frozen_string_literal: true

require 'selenium-webdriver'

class AutoSearch
  def self.call(search_keywork, website_title, run_times = 100)
    new(search_keywork, website_title, run_times).call
  end

  GOOGLE_URL = 'http://google.com'

  attr_accessor :search_keywork, :website_title, :run_times,
                :driver, :break_loop, :trgger_element, :page_number

  def initialize(search_keywork, website_title, run_times)
    @search_keywork = search_keywork
    @website_title = website_title
    @run_times = run_times
  end

  def call
    puts "search_keywork: #{search_keywork}\ntrigger website: #{website_title}\n-\n"
    run_times.times do |i|
      puts "Run time: #{i + 1}"
      setup
      goto_google_and_search
      search_trigger

      sleep 1
    end
  end

  def setup
    @driver = Selenium::WebDriver.for :chrome
    @break_loop = false
    @trgger_element = nil
    @page_number = 1
  end

  def goto_google_and_search
    driver.navigate.to GOOGLE_URL

    element = driver.find_element(name: 'q')
    element.send_keys search_keywork
    element.submit
  end

  def search_trigger
    loop do
      search_trigger_find_scope
      if break_loop
        search_trigger_found
        break
      end

      search_trigger_next_page
      sleep 1
    end
  end

  def search_trigger_find_scope
    sleep 300
    driver.find_elements(class: 'LC20lb').each do |e|
      if e.text == website_title
        @trgger_element = e
        @break_loop = true
      end
    end
  end

  def search_trigger_next_page
    driver.find_elements(class: 'pn').last.click

    @page_number += 1
  end

  def search_trigger_found
    trgger_element.click
    puts "#{website_title} in google search of #{page_number} found."
    driver.quit
  end
end
