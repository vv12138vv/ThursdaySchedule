import { LogUtils } from '../utils/LogUtils';

export namespace theme {

  export function getTheme(theme: number): Resource {
    LogUtils.debug("颜色", `${theme}`)
    if (theme == 1) return $r('app.color.system_color_1');
    else if (theme == 2) return $r('app.color.system_color_2');
    else if (theme == 3) return $r('app.color.system_color_3');
    else if (theme == 4) return $r('app.color.system_color_4');
    else if (theme == 5) return $r('app.color.system_color_5');
    else if (theme == 6) return $r('app.color.system_color_6');
    else if (theme == 7) return $r('app.color.system_color_7');
    else if (theme == 8) return $r('app.color.system_color_8');
  }

  export function getBackground(bg: number): Resource {
    if (bg == 1) return $r('app.media.back_mine1');
    if (bg == 2) return $r('app.media.back_mine2');
    if (bg == 3) return $r('app.media.back_mine3');
    if (bg == 4) return $r('app.media.back_mine4');
    if (bg == 5) return $r('app.media.back_mine5');
    if (bg == 6) return $r('app.media.back_mine6');
    if (bg == 7) return $r('app.media.back_mine7');
    if (bg == 8) return $r('app.media.back_mine8');
    if (bg == 9) return $r('app.media.back_mine9');
  }
}