#https://www.shadertoy.com/view/stXXWn
# based on/simplified

def mainImage(fragColor, fragCoord)
    uv = vec2 fragCoord/iResolution.y;
    uv -= iResolution.xy/iResolution.y*0.5;
    cuv = vec2(2.0*length(uv), atan(uv.x, uv.y));
    cuv.x -= cos(0.5*iTime);
    td = clamp(pow(2.0/length(vec2(cuv.x, 0)),2.0), 0.0, 1.0);
    strip = (-sin(10.0*(cuv.x-cuv.y))-0.5);
    $fragColor = vec4((strip+0.6)*td,(strip+0.6)*td,(strip+0.6)*td,1.0);
end

# void mainImage( out vec4 fragColor, in vec2 fragCoord ) {
#     vec2 uv = fragCoord/iResolution.y;
#     uv -= iResolution.xy/iResolution.y*0.5;
#     vec2 cuv = vec2(2.0*length(uv), atan(uv.x, uv.y));
#     cuv.x -= cos(0.5*iTime);
#     float td = clamp(pow(2.0/length(cuv.x),2.0), 0.0, 1.0);
#     float strip = (-sin(10.0*(cuv.x-cuv.y))-0.5);
#     fragColor = vec4((strip+0.6)*td);
# }