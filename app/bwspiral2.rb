# implementation of
# http://glslsandbox.com/e#73894.0

##define size 10.0
$size = 10.0

def mainImage(fragColor, fragCoord)

    # vec2 uv = fragCoord/iResolution.y;
    uv = fragCoord/iResolution.y;

    # uv -= iResolution.xy/iResolution.y*0.5;
    uv -= iResolution.xy/iResolution.y*0.5;

    # vec2 cuv = vec2(2.0*length(uv), atan(uv.x, uv.y));
    cuv = vec2(2.0*length(uv), atan(uv.x, uv.y));

    # cuv.x = mix(cuv.x, 2.0/cuv.x, 0.7);
    cuv.x = mix(cuv.x, 2.0/cuv.x, 0.7);

    # cuv.x -= cos(0.5*iTime);
    cuv.x -= cos(0.5*iTime);

    # float td = (pow(0.3/length(cuv.x),1.0));
    td = (pow(0.3/length(cuv.x),1.0));

    # float strip1 = step(-sin(size*(cuv.x-cuv.y)), -0.5);
    strip1 = step(-sin($size*(cuv.x-cuv.y)), -0.5);

    # float strip2 = step(-sin(size*(cuv.x+cuv.y)), -0.1)*step(sin(size*(cuv.x-cuv.y)), -0.0);
    strip2 = step(-sin($size*(cuv.x+cuv.y)), -0.1)*step(sin($size*(cuv.x-cuv.y)), -0.0);
    
    # fragColor = vec4((strip1*4.+2.*strip2)*td);
    $fragColor = vec4(c=(strip1*4.0+2.0*strip2)*td,c,c,c);
end

=begin GLSL code
#ifdef GL_ES
precision mediump float;
#endif

// glslsandbox uniforms
uniform float time;
uniform vec2 resolution;

// shadertoy emulation
#define iTime time
#define iResolution resolution

// --------[ Original ShaderToy begins here ]---------- //
#define pi acos(-1.0)
#define saturate(t) clamp(t, 0.0, 1.0)
#define size 10.0

void mainImage( out vec4 fragColor, in vec2 fragCoord ) {
    vec2 uv = fragCoord/iResolution.y;
    uv -= iResolution.xy/iResolution.y*0.5;
    vec2 cuv = vec2(2.0*length(uv), atan(uv.x, uv.y));
    cuv.x = mix(cuv.x, 2.0/cuv.x, 0.7);
    cuv.x -= cos(0.5*iTime);
    float td = (pow(0.3/length(cuv.x),1.0));
    float strip1 = step(-sin(size*(cuv.x-cuv.y)), -0.5);
    float strip2 = step(-sin(size*(cuv.x+cuv.y)), -0.1)*step(sin(size*(cuv.x-cuv.y)), -0.0);
    fragColor = vec4((strip1*4.+2.*strip2)*td);
}
// --------[ Original ShaderToy ends here ]---------- //

void main(void)
{
    mainImage(gl_FragColor, gl_FragCoord.xy);
}
=end