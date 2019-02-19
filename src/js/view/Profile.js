import { section, h1, a, ul, li } from '@hyperapp/html'

export default () => state =>
  section([
    h1('I\'m belong to...'), 
    ul([
      li([
        a({ href: 'http://spacemgz-telstar.com/', target: '_blank' }, '宇宙広報団体 TELSTAR')
      ]),
      li([
        a({ href: 'https://sorabatake.jp/', target: '_blank' }, '宙畑')
      ])
    ])
  ])