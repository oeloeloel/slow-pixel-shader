def mainImage(frag)
  pos_x = (frag.x / $iResolution_x) * 26.0 - 13.0
  pos_y = (frag.y / $iResolution_y) * 26.0 - 13.0

  x = sin($iTime + length(pos_x, pos_y)) + cos(($mouse_x * 10.0) + pos_x)
  y = cos($iTime + length(pos_x, pos_y)) + sin(($mouse_y * 10.0) + pos_y)

  frag.r = x * 0.5
  frag.g = y * 0.5
  frag.b = x * y
end