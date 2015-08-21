class SearchGithub

  attr_accessor :keyword

  def initialize
    @agent = Mechanize.new
  end

  def search
    page = @agent.get('https://github.com')
    search_form = page.forms.first
    search_form.q = keyword
    @agent.submit(search_form, search_form.buttons.first)
  end

  def get_code_results(results)
    results.links_with(:text => /Code/).first.click
  end

  def accumulate_results(results)
    links = results.links
    lower_index, upper_index = get_lower_upper_index(results)
    result_links = []
    links.each_with_index { |link, i|
      result_links << link if i > links.find_index(lower_index) && i < links.find_index(upper_index)
    }
    required_links = []
    result_links.each { |link| required_links << link.href unless link.href =~ /\#[L]\d*$/ }
    required_links.each_slice(3).to_a
  end

  def random_seconds
    rand(3..20)
  end

  def fetch_links(results)
    code_results = get_code_results(results)
    pages_to_traverse = no_of_page(code_results)
    required_links = accumulate_results(code_results)
    puts "Result fetched : #{required_links.count}"
    fetch_code_links(pages_to_traverse, code_results, required_links)
    required_links
  end

  private

  def get_lower_upper_index(results)
    count = (total_results_count(results)/10.to_f).ceil
    if count < 2
      [results.links_with(:text => /Cheat sheet/).first, results.links_with(:text => /\(see all\)/).first]
    else
      [results.links_with(:text => /Least recently indexed/).first, results.links_with(:href => /\/search\?p=/).first]
    end
  end

  def total_results_count(results)
    results.links_with(:text => /Code/).first.text.split(/Code/).last.tr(',', '').to_i
  end

  def no_of_page(results)
    pages = (total_results_count(results)/10.to_f).ceil
    pages > 5 ? 5 : pages
  end

  def fetch_code_links(pages_to_traverse, code_results, required_links)
    if pages_to_traverse > 1
      next_page = code_results.links_with(:text => /Next/).first
      (2..pages_to_traverse).each do
        time = random_seconds 
        puts "Sleeping for #{time}s..."
        sleep(time)
        new_results = next_page.click
        accumulate_results(new_results).each { |result| required_links << result }
        puts "Result fetched : #{required_links.count}"
        next_page = new_results.links_with(:text => /Next/).first
      end
    end
  end

end
