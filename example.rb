# frozen_string_literal: true

require './auto_search'

search_keywork = 'AmigoCDN'
your_website_title = '內容傳遞網路(CDN) - AmigoCDN'
run_times = 3

AutoSearch.call(search_keywork, your_website_title, run_times)
