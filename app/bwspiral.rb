#https://www.shadertoy.com/view/stXXWn

#define pi acos(-1.0)
#define saturate(t) clamp(t, 0.0, 1.0)
#define size 10.0
#// Anti-Aliased smoothstep proposed by FabriceNeyret2
#define S(v) smoothstep(-1.,1.,(v)/fwidth(v))

def mainImage(fragColor, fragCoord)
    uv = vec2 fragCoord/iResolution.y;
    # puts uv
    # uv -= iResolution.xy/iResolution.y*0.5;
    # cuv = vec2(2.0*length(uv), atan(uv.x, uv.y));
    # cuv.x = mix(cuv.x, 2.0/cuv.x, smoothstep(-1.0, 1.0, clamp(2.0*sin(0.5*iTime), -1.0, 1.0)));
    # cuv.x -= cos(0.5*iTime);
    # float td = saturate(pow(2.0/length(cuv.x),2.0));
    # float strip1 = S(-sin(size*(cuv.x-cuv.y))-0.5);
    # float strip2 = S(-sin(size*(cuv.x+cuv.y))-0.5)*S(sin(size*(cuv.x-cuv.y)));
    # fragColor = vec4((strip1+0.6*strip2)*td);
end