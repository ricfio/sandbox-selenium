#!/usr/local/bin/python

import sys
from selenium.webdriver import Chrome, ChromeOptions
from selenium.webdriver.chrome.service import Service
from webdriver_manager.chrome import ChromeDriverManager

chrome_driver = ChromeDriverManager().install()

chrome_options = ChromeOptions()
# chrome_options.add_argument('--headless')
chrome_options.add_argument('--no-sandbox')
# chrome_options.add_argument('--display=:0.0')
chrome_options.add_argument('--disable-dev-shm-usage')

browser = Chrome(service=Service(chrome_driver), options=chrome_options)
browser.get('https://github.com/ricfio/sandbox-selenium')

if sys.stdin.isatty():
    input("\n*** Press [RETURN] to close the browser and terminate script execution ***\n")

browser.quit()
