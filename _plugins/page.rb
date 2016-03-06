# http://brizzled.clapper.org/blog/2010/12/20/some-jekyll-hacks/
module Jekyll

  # Extensions to the Jekyll Page class.
  # Make page.full_url return the full URL of the page

  class Page

    # Full URL of the page.
    def full_url
        File.join(@dir, self.url)
    end

    alias orig_to_liquid to_liquid
    def to_liquid
        h = orig_to_liquid
        h['max_top'] = (self.data['max_top'] ||
                        site.config['max_top'] ||
                        15)
        # h['date'] = self.date
        h
    end

    #def tags
    #  (self.data['tags'] || '').split(',').map {|t| Tag.new(t)}
    #end

  end
end
