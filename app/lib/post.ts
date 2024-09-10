import type { JSX } from 'hono/jsx/jsx-runtime'
import type { MDXProps } from 'mdx/types'
import type { Meta } from '../types'

export type MDX = {
  frontmatter: Meta
  default: (props: MDXProps) => JSX.Element
}

const posts = import.meta.glob<MDX>('../posts/*.md', {
  eager: true
})

const sortByDateDesc = ():
  | ((a: [string, { frontmatter: Meta }], b: [string, { frontmatter: Meta }]) => number)
  | undefined => {
  return ([_aid, aPost], [_bid, bPost]) => {
    const aDate = new Date(aPost.frontmatter.pubDate)
    const bDate = new Date(bPost.frontmatter.pubDate)
    return aDate.getTime() < bDate.getTime() ? 1 : -1
  }
}

export const getPosts = () => {
  const postsData = Object.entries(posts)
    .sort(sortByDateDesc())
    .map(([path, post]) => {
      const entryName = getEntryNameFromPath(path)
      const { frontmatter } = post
      const { default: Component } = post
      return { entryName, frontmatter, Component }
    })
  return postsData
}

export const getPostByEntryName = (entryName: string) => {
  const posts = getPosts()
  const post = posts.find((post) => post.entryName === entryName)
  return post
}

export const getLatestPostsWithoutTargetPost = (postEntryName: string) => {
  const posts = getPosts()
  const latestPosts = posts.filter((post) => post.entryName !== postEntryName)
  return latestPosts.slice(0, 3)
}

// UTILITIES

const getEntryNameFromPath = (path: string) => {
  const match = path.match(/([^/]+)\.md$/)
  if (!match) {
    throw new Error(`Invalid path: ${path}`)
  }
  return match[1]
}
