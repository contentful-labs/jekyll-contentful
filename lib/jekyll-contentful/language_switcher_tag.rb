module Jekyll
  class LanguageSwitcherTag < Liquid::Tag

    def initialize(tag_name, text, tokens)
      super
      @text = text
    end

    def render(context)
      @site = context.registers[:site]
      this_page = context.registers[:page]
      
      return "" if @site.config['contentful']['localization'].nil? || this_page["contentful_id"].nil?

      translated_pages = @site.pages.flatten.select do |that_page| 
        that_page["contentful_id"] == this_page["contentful_id"] and that_page["locale"] != this_page["locale"]
      end

      if translated_pages.length > 1
        list = translated_pages.dup.map do |tp|
          "<li translation-item>#{anchor(tp)}</li>"
        end.join(' ,')
        return "<ul class='translation-list'>#{list}</uL>"
      else
        return anchor(translated_pages[0])
      end
    end

    def anchor(page)
      lang = @site.config['contentful']['localization'].detect{ |loc| loc["locale"] == page['locale']}["lang"]
      "<a class='translation-link lang-#{page['locale']}' href='#{ page['url']}'>#{ lang }</a>"
    end
  end
end

Liquid::Template.register_tag('language_switcher', Jekyll::LanguageSwitcherTag)