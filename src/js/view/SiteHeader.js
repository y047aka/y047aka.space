import { div, span, header, h1, p, img } from '@hyperapp/html'

export default () => state =>
  header({ class: 'site-header' }, [
    div({ class: 'icon' }),
    h1([
      '戸塚 孝高',
      span('Yoshitaka Totsuka / y047aka')        
    ]),
    p([
      img({ src: '/images/location.svg' }),
      'Tokyo, Japan'
    ])
  ])
