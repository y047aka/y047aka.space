import { css } from 'hono/css'
import type { FC } from 'hono/jsx'

export const LinkTile: FC = (props) => {
  const tileCSS = css`
    display: block;
    padding: 20px;
    line-height: 1.5;
    font-size: 16px;
    font-weight: 600;
    text-decoration: none;
    border-radius: 10px;
    background: hsl(210 5% 95%);
    color: hsl(0 0% 20%);

    &:hover {
      background: hsl(210 5% 90%);
    }
  `

  const spanCss = css`
    display: block;
    line-height: 1;
    font-size: 13px;
    font-weight: 400;
    color: hsl(0 0% 40%);
  `

  return (
    <a class={tileCSS} href={props.url}>
      {props.title}
      <span class={spanCss}>{props.subTitle}</span>
    </a>
  )
}
