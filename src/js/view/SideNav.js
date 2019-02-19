import { nav, a, ul, li, img } from '@hyperapp/html'

export default () => state =>
	nav({ class: 'side-nav' }, [
		ul([
			li([
				a({ href: 'https://github.com/y047aka', target: '_blank' }, [
					img({ src: '/images/github.svg' })
				])
			]),
			li([
				a({ href: 'https://twitter.com/y047aka', target: '_blank' }, [
					img({ src: '/images/twitter.svg' })
				])
			])
		])
  ])
