import { Hono } from 'hono'
import { ssgParams } from 'hono/ssg'
import { jsxRenderer } from 'hono/jsx-renderer'
import { getPosts } from './lib/post'

const app = new Hono()

app.all(
  '*',
  jsxRenderer(({ children }) => {
    return (
      <html>
        <link href="/static/style.css" rel="stylesheet" />
        <body>
          <header>
            <a href="/">top</a> &nbsp;
          </header>
          <main>{children}</main>
        </body>
      </html>
    )
  })
)

app.get('/', (c) => {
  return c.render(
    <ul>
      {posts.map((post) => {
        return (
          <li>
            <a href={`/posts/${post.slug}`}>{post.title}</a>
          </li>
        )
      })}
    </ul>
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
        <h1>{post.title}</h1>
        <div>投稿日: {post.pubDate}</div>
        <hr />
        <div dangerouslySetInnerHTML={{ __html: post.body }}></div>
      </>
    )
  }
)

app.get('/status', ssgParams(false), (c) => c.json({ ok: true }))

app.get('/404', (c) => c.notFound())

export default app
