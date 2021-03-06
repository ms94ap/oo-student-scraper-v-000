require 'open-uri'
require 'pry'
require 'nokogiri'

class Scraper

  def self.scrape_index_page(index_url)
    doc = Nokogiri::HTML(open("http://46.101.242.134:3202/fixtures/student-site/index.html"))
    scraped_students = []
    # binding.pry
    doc.css("div.roster-cards-container").each do |all_cards|
      all_cards.css(".student-card").each do |student|
        student_url = "http://46.101.242.134:3202/#{student.css("a").attr("href").value}"
        student_name = student.css(".student-name").text
        student_location = student.css(".student-location").text

        scraped_students << {name: student_name, location: student_location, profile_url: student_url}
      end
    end

    scraped_students
  end

  def self.scrape_profile_page(profile_url)
    student = {}
    profile_page = Nokogiri::HTML(open(profile_url))
    links = profile_page.css(".social-icon-container").children.css("a").map { |el| el.attribute('href').value}
    links.each do |link|
      if link.include?("linkedin")
        student[:linkedin] = link
      elsif link.include?("github")
        student[:github] = link
      elsif link.include?("twitter")
        student[:twitter] = link
      else
        student[:blog] = link
      end
    end
    student[:profile_quote] = profile_page.css(".profile-quote").text if profile_page.css(".profile-quote")
    student[:bio] = profile_page.css("div.bio-content.content-holder div.description-holder p").text if profile_page.css("div.bio-content.content-holder div.description-holder p")

   student
  end
end
