import { footer, p, a, ul, li, img } from '@hyperapp/html'

export default () => state =>
  footer({ class: 'site-footer' }, [
    ul([
      li([
        a({ href: 'https://twitter.com/y047aka', target: '_blank' }, [
          img({ src: '/images/twitter.svg' })
        ])
      ]),
      li([
        a({ href: 'https://github.com/y047aka', target: '_blank' }, [
          img({ src: '/images/github.svg' })
        ])
      ])
    ]),
    p({ class: 'copyright', innerHTML: `&copy; 2018-${ new Date().getFullYear() } y047aka` })
  ])
