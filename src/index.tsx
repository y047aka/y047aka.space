import { Hono } from 'hono'
import { ssgParams } from 'hono/ssg'
import { css } from 'hono/css'
import { jsxRenderer } from 'hono/jsx-renderer'
import { baseURL, siteName } from './lib/constants'
import { getPosts } from './lib/post'
import { Layout } from './components/Layout'
import { LinkTile } from './components/LinkTile'
import { MarkdownRenderer } from './components/MarkdownRenderer'

const app = new Hono()

type Metadata = {
  title: string
  url: string
  description: string
  ogImage?: string
}

let metadata: Metadata = {
  title: siteName,
  url: baseURL,
  description: '',
  ogImage: '/placeholder-social.jpeg'
}

app.all(
  '*',
  jsxRenderer(({ children }) => <Layout metadata={metadata}>{children}</Layout>)
)

app.get('/', (c) => {
  return c.render(
    <div class={css`display: flex; flex-direction: column; row-gap: 5px;`}>
      {posts.map((post) => {
        return <LinkTile title={post.title} subTitle={post.pubDate} url={`/posts/${post.slug}`} />
      })}
    </div>
  )
})
const posts = await getPosts()

app.get(
  '/posts/:slug',
  ssgParams(() => posts),
  (c) => {
    const post = posts.find((p) => p.slug === c.req.param('slug'))
    if (!post) {
      return c.redirect('/404')
    }
    return c.render(
      <>
        <h1
          class={css`font-family: "-apple-system", sans-serif; font-size: 24px; font-weight: 600;`}
        >
          {post.title}
        </h1>
        <div class={css`font-size: 14px; line-height: 1; color: hsl(210 5% 50%);`}>
          {post.pubDate}
        </div>
        <MarkdownRenderer {...post} />
      </>
    )
  }
)

app.get('/status', ssgParams(false), (c) => c.json({ ok: true }))

app.get('/404', (c) => c.notFound())

export default app
