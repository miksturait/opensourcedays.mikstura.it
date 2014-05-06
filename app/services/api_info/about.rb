class ApiInfo::About
  class << self
    def data
      {
          info: t('meta.description'),
          icons: {
              iphone: icon_path('iphone'),
              ipad: icon_path('ipad'),
              iphone_retina: icon_path('iphone-retina'),
              ipad_retina: icon_path('ipad-retina'),

          },
          links: {
              conference: domain,
              twitter: "https://twitter.com/miksturait",
              facebook: t('links.facebook'),
              google: "https://google.com/+MiksturaIt_Foundation"
          },
          audiostream: {
              icon: "http://dwo.mikstura.it/assets/layout/dwo.png",
              url: "http://wbur-sc.streamguys.com/wbur.mp3"
          },
          title: t('only_title'),
          subtitle: t('subtitle'),
          short_title: t('short_title'),
          hashtag: t('hashtag'),
          location: t('location'),
          intro_url: 'http://dwo.mikstura.it/assets/layout/backgrounds/intro_small.jpg'
      }
    end

    private

    def icon_path(icon)
      link_to("assets/layout/touch/#{icon}.png")
    end

    def link_to(path)
      [domain, path].join('/')
    end

    def domain
      t(:domain)
    end

    def t(*args)
      I18n.t(args).first
    end
  end
end