import { Style, css } from 'hono/css'
import type { FC } from 'hono/jsx'
import { jsxRenderer } from 'hono/jsx-renderer'
import { Footer } from '../components/Footer'
import { Header } from '../components/Header'
import { baseURL, siteName } from '../lib/constants'

export default jsxRenderer(({ children, title, frontmatter }) => {
  return (
    <html lang="ja">
      <Head title={title} frontmatter={frontmatter} />
      <body>
        <Header />
        <main>{children}</main>
        <Footer />
      </body>
    </html>
  )
})

const Head: FC = ({ title, frontmatter }) => {
  return (
    <head>
      <meta charset="UTF-8" />
      <meta name="viewport" content="width=device-width, initial-scale=1.0" />
      <title>{title ?? frontmatter?.title ?? siteName}</title>
      <link rel="stylesheet" href="https://unpkg.com/ress/dist/ress.min.css" />
      <link rel="preconnect" href="https://fonts.googleapis.com" />
      <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin="" />
      <link
        rel="stylesheet"
        href="https://fonts.googleapis.com/css2?family=Saira:wght@400;500&display=swap"
      />
      <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.15.1/css/all.css" />
      <Style>{globalCss}</Style>
      <link rel="icon" href="/favicon.ico" />
      <link rel="sitemap" href="/sitemap.xml" />
      {/* <meta name="title" content={frontmatter.title} />
      <meta name="description" content={frontmatter.description} /> */}
      {/* Open Graph / Facebook */}
      <meta property="og:type" content="website" />
      <meta property="og:url" content={baseURL} />
      {/* <meta property="og:title" content={frontmatter.title} />
      <meta property="og:description" content={frontmatter.description} /> */}
      {/* <meta property="og:image" content={props.metadata.ogImage} /> */}
      {/* Twitter Card */}
      <meta property="twitter:card" content="summary_large_image" />
      <meta property="twitter:url" content={baseURL} />
      {/* <meta property="twitter:title" content={frontmatter.title} />
      <meta property="twitter:description" content={frontmatter.description} /> */}
      {/* <meta property="twitter:image" content={props.metadata.ogImage} /> */}
    </head>
  )
}

const globalCss = css`
  body {
    min-height: 100dvh;
    display: grid;
    grid-template-columns: 100%;
    grid-template-rows: auto 1fr auto;

    font-family: "-apple-system", "BlinkMacSystemFont", sans-serif;
    font-feature-settings: "palt";
    background-color: hsl(0 0% 98%);
    color: hsl(0 0% 20%);
  }

  main {
    padding: 30px 15px;
    display: flex;
    flex-direction: column;
    row-gap: 30px;
    background-color: hsl(0 0% 100%);

    * {
      width: 100%;
      max-width: 620px;
      margin-inline: auto;
    }
  }
  `
