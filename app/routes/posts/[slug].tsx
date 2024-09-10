import { css } from 'hono/css'
import { ssgParams } from 'hono/ssg'
import { createRoute } from 'honox/factory'
import { getLatestPostsWithoutTargetPost, getPostByEntryName, getPosts } from '../../lib/post'

export default createRoute(
  ssgParams(() => {
    const posts = getPosts()
    return posts.map((post) => ({
      slug: post.entryName
    }))
  }),
  async (c) => {
    const slug = c.req.param('slug')
    if (slug === ':slug') {
      c.status(404)
      return c.notFound()
    }

    const post = getPostByEntryName(slug)
    const pageTitle = post?.frontmatter.title ?? ''
    const pubDate = post?.frontmatter.pubDate ?? ''

    return c.render(
      <>
        <header>
          <h1
            class={css`font-family: "-apple-system", sans-serif; font-size: 24px; font-weight: 600;`}
          >
            {pageTitle}
          </h1>
          <div class={css`font-size: 14px; line-height: 1; color: hsl(210 5% 50%);`}>{pubDate}</div>
        </header>
        <div class={markdownCSS}>{post?.Component({})}</div>
      </>
    )
  }
)

const markdownCSS = css`
  line-height: 1.8;
  word-wrap: break-word;

  blockquote, details, dl, ol, p, pre, table, ul, .expressive-code {
    & + blockquote, & + details, & + dl, & + ol, & + p, & + pre, & + table, & + ul, & + .expressive-code {
      margin-top: 29px;
    }
  }

  figure {
    box-shadow: none !important;
  }

  code, pre {
    font-family: "SFMono-Regular", "Consolas", "Liberation Mono", "Menlo", monospace;
    font-size: 12px;
  }

  pre {
    word-wrap: normal;

    & > code {
      margin: 0;
      padding: 0;
      font-size: 100%;
      word-break: normal;
      white-space: pre;
      background-color: transparent;
      border: 0;
    }
  }

  pre {
    padding: 16px;
    overflow-x: auto;
    font-size: 85%;
    line-height: 1.45;
    background-color: #f6f8fa !important;
    border-radius: 3px !important;
    border: none !important;

    code {
      display: inline;
      max-width: auto;
      margin: 0;
      padding: 0;
      overflow-x: visible;
      line-height: inherit;
      word-wrap: normal;
      background-color: initial;
      border: 0;
    }
  }

  h1, h2, h3, h4, h5, h6 {
    font-weight: 600;

    &:nth-child(n+2) {
      margin-top: 29px;
    }
  }

  h2 {
    margin-block: 28px;
    padding-block: 17px;
    text-align: center;
    font-size: 1.125em;
    line-height: 1.333;
    border-top: 1px solid;
    border-bottom: 1px solid;
  }

  h3 {
    margin-top: 2px;
    margin-bottom: 31px;
    font-size: 1.25em;
    line-height: 1.25;
  }

  h4, h5 {
    font-size: 1em;
  }

  hr {
    height: 0;
    padding: 0;
    margin-block: 24px;
    border-top-width: 1px solid #e1e4e8;
  }

  blockquote {
    padding-left: 1em;
    color: #6a737d;
    border-width: 0;
    border-left-width: 0.25em solid #dfe2e5;
  }

  code {
    margin: 0;
    padding: 0.2em 0.4em;
    font-size: 85%;
    background-color: rgba(27 31 35 / 0.05);
    border-radius: 3px;
  }

  a {
    white-space: pre-wrap;
    text-decoration: none;
    color: hsl(90, 100%, 40%);

    &:hover {
      text-decoration: underline;
    }

    &:visited {
      color: hsl(90, 100%, 25%);
    }
  }

  img {
    max-width: 100%;
  }

  ul, ol {
    padding-left: 2em;

    ol {
      list-style-type: lower-roman;
    }

    ol ol, ul ol {
      list-style-type: lower-alpha;
    }
  }

  li {
    &:nth-child(n+2) {
      margin-top: 0.25em;
    }

    & > p {
      margin-top: 16px;
    }
  }

  table {
    display: block;
    width: 100%;
    overflow-x: auto;
    border-spacing: 0;
    border-collapse: collapse;

    tr {
      background-color: #fff;
      border-top: 1px solid #c6cbd1;

      &:nth-child(2n) {
        background-color: #f6f8fa;
      }
    }

    th, td {
      padding: 6px 13px;
      border: 1px solid #dfe2e5;
    }

    th {
      font-weight: 600;
    }
  }

`
