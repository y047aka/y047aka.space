import { css } from 'hono/css'
import { FC } from 'hono/jsx'

export const TopSection: FC = (props) => {
  const topSectionCSS = css`
    display: flex;
    flex-direction: column;
    row-gap: 10px;

    h2 {
        font-family: "Saira", sans-serif;
        font-size: 16px;
        font-weight: 600;
        line-height: 1;
    }
  `

  return (
    <section class={topSectionCSS}>
      <h2>{props.title}</h2>
      {props.children}
    </section>
  )
}
