module Nesta
  module Overrides
    module Renderers
      
      def auto(template, options = {}, locals = {})
        defaults, engine =options[:views].nil? ? Overrides.render_options(template, :haml, :erb, :erubis, :markdown, :sass, :scss, :htmf) :
            Overrides.render_options_for_path(options[:views],template, :haml, :erb, :erubis, :markdown, :sass, :scss, :htmf)
        renderer = Sinatra::Templates.instance_method(engine)
        renderer.bind(self).call(template, defaults.merge(options), locals)
      end
      
      def haml(template, options = {}, locals = {})
        defaults, engine = Overrides.render_options(template, :haml)
        super(template, defaults.merge(options), locals)
      end

      def erb(template, options = {}, locals = {})
        defaults, engine = Overrides.render_options(template, :erb)
        super(template, defaults.merge(options), locals)
      end

      def sass(template, options = {}, locals = {})
        defaults, engine = Overrides.render_options(template, :sass)
        super(template, defaults.merge(options), locals)
      end
      
      def scss(template, options = {}, locals = {})
        defaults, engine = Overrides.render_options(template, :scss)
        super(template, defaults.merge(options), locals)
      end



      def stylesheet(template, options = {}, locals = {})
        defaults, engine = Overrides.render_options(template, :sass, :scss)
        renderer = Sinatra::Templates.instance_method(engine)
        renderer.bind(self).call(template, defaults.merge(options), locals)
      end
    end

    def self.load_local_app
      require Nesta::Path.local("app")
    rescue LoadError
    end
    
    def self.load_theme_app
      if Nesta::Config.theme
        require Nesta::Path.themes(Nesta::Config.theme, "app")
      end
    rescue LoadError
    end

    private
      def self.template_exists?(engine, views, template)
        views && File.exist?(File.join(views, "#{template}.#{engine}"))
      end

      def self.render_options_for_path(path, template, *engines)
        engines.each do |engine|
          if template_exists?(engine, path, template)
            return { :views => path }, engine
          end
        end
        
        [{}, :sass]
      end
      
      def self.render_options(template, *engines)
        [local_view_path, theme_view_path, Nesta::Path.local("content/pages")].each do |path|
          engines.each do |engine|
            if template_exists?(engine, path, template)
              return { :views => path }, engine
            end
          end
        end
        [{}, :sass]
      end

      def self.local_view_path
        Nesta::Path.local("views")
      end
    
      def self.theme_view_path
        if Nesta::Config.theme.nil?
          nil
        else
          Nesta::Path.themes(Nesta::Config.theme, "views")
        end
      end
  end
end
