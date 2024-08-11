import { Style, css } from 'hono/css'
import type { FC } from 'hono/jsx'
import { owner, siteName } from '../lib/constants'

export const Layout: FC = (props) => {
  const globalCSS = css`
    font-family: "-apple-system", "BlinkMacSystemFont", sans-serif;
    font-feature-settings: "palt";
    color: hsl(0 0% 20%);

    main {
      max-width: 620px;
      margin-inline: auto;
      padding: 40px 15px;
    }
  `

  return (
    <html lang="ja">
      <Head metadata={props.metadata} />
      <body class={globalCSS}>
        <Header {...props} />
        <main>{props.children}</main>
        <Footer />
      </body>
    </html>
  )
}

const Head: FC = (props) => {
  return (
    <head>
      <title>{props.metadata.title}</title>
      <link rel="stylesheet" href="https://unpkg.com/ress/dist/ress.min.css" />
      <link rel="preconnect" href="https://fonts.googleapis.com" />
      <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin="" />
      <link
        rel="stylesheet"
        href="https://fonts.googleapis.com/css2?family=Saira:wght@400;500&display=swap"
      />
      <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.15.1/css/all.css" />
      <Style />
      <link rel="icon" type="image/svg+xml" href="/favicon.ico" />
      <link rel="sitemap" href="/sitemap.xml" />
      <meta charset="utf-8" />
      <meta name="viewport" content="width=device-width,initial-scale=1" />
      <meta name="title" content={props.metadata.title} />
      <meta name="description" content={props.metadata.description} />
      {/* Open Graph / Facebook */}
      <meta property="og:type" content="website" />
      <meta property="og:url" content={props.metadata.url} />
      <meta property="og:title" content={props.metadata.title} />
      <meta property="og:description" content={props.metadata.description} />
      <meta property="og:image" content={props.metadata.ogImage} />
      {/* Twitter Card */}
      <meta property="twitter:card" content="summary_large_image" />
      <meta property="twitter:url" content={props.metadata.url} />
      <meta property="twitter:title" content={props.metadata.title} />
      <meta property="twitter:description" content={props.metadata.description} />
      <meta property="twitter:image" content={props.metadata.ogImage} />
    </head>
  )
}

const Header: FC = (props) => {
  const headerCSS = css`
    border-bottom: 1px solid hsl(0 0% 90%);

    h2 {
      max-width: 620px;
      margin-inline: auto;
      padding: 15px;
      font-family: "Saira", sans-serif;
      font-size: 18px;
      font-weight: normal;
    }
    a {
      text-decoration: none;
      color: inherit;
    }
  `

  const path = new URL(props.metadata.url).pathname
  return (
    <header class={headerCSS}>
      <h2>
        <a href="/">{siteName}</a>
      </h2>
    </header>
  )
}

const Footer: FC = () => {
  const footerCSS = css`
    border-top: 1px solid hsl(0 0% 90%);

    div {
      max-width: 620px;
      margin-inline: auto;
      padding: 15px;
      text-align: right;
      font-family: "Saira", sans-serif;
      font-size: 14px;
    }
  `

  return (
    <footer class={footerCSS}>
      <div>© 2024 {owner}</div>
    </footer>
  )
}
