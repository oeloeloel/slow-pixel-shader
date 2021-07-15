$gtk.reset

class Pixel
  attr_accessor :x, :y, :r, :g, :b, :a

  def initialize args, x, y, scale, r, g, b
    @x = x
    @y = y
    @w = scale
    @h = scale
    # @r, @g, @b = r, g, b # maybe or maybe not needed

    $vec2_pool = []
    $vec3_pool = []
    $vec4_pool = []
    args.outputs.static_solids << self
  end

  def draw_override ffi_draw
    # $fragColor = vec4.new(@r, @g, @b, 1) # maybe or maybe not needed
    $fragCoord.x = @x
    $fragCoord.y = @y

    $vec2_counter = 0
    $vec3_counter = 0
    $vec4_counter = 0

    mainImage($fragColor, $fragCoord)
    @r = $fragColor.x
    @g = $fragColor.y
    @b = $fragColor.z

    ffi_draw.draw_solid(
      @x * @w,
      @y * @h,
      @w, @h,
      @r * 255, @g * 255, @b * 255, nil
    )
  end
end

module Shader
  include Math
  include Geometry

  def self.setup(args, w, h, scale)
    @w, @h, @scale = w, h, scale
    $pixels = make_pixels(args)
    $iResolution = Vec3.new(w, h, 1)
    $start_time = Time.now.to_f
    $fragColor = Vec4.new(0.0, 0.0, 0.0, 0.0)
    $fragCoord = Vec2.new(0.0, 0.0)
  end

  def self.make_pixels(args)
    pixels = []
    y = 0
    while y < @h do
      x = 0
      while x < @w do
        pixels << Pixel.new(args, x, y, @scale, 0, 0, 0)
        x += 1
      end
      y += 1
    end
    pixels
  end

  def self.shader_tick(args)
    $mouse_x = args.mouse.x / ($iResolution.x * @scale)
    $mouse_y = args.mouse.y / ($iResolution.y * @scale)
    $iTime = Time.now.to_f - $start_time
  end

  def iTime
    $iTime
  end

  def iResolution
    $iResolution
  end

  def radians(degrees)
    degrees.to_radians
  end

  def degrees(radians)
    radians.to_degrees
  end

  def cos(*params)
    if params[0].is_a? Vec3
      Vec3.new(
        Math.cos(params[0].x),
        Math.cos(params[0].y),
        Math.cos(params[0].z)
      )
    else
      Math.cos(params[0])
    end
  end

  def pow(x, y)
    x**y
  end

  def inversesqrt(x)
    return if x <= 0

    1 / sqrt(x)
  end

  def abs(x)
    x.abs
  end

  def sign(x)
    return -1.0 if x < 0

    return 1.0 if x > 0

    0.0
  end

  def floor(x)
    x.floor
  end

  def ceil(x)
    x.ceil
  end

  def trunc(x)
    x.truncate
  end

  def fract(x)
    x - x.floor
  end

  def mod(x, y)
    x % y
  end

  def min(x, y)
    x < y ? x : y
  end

  def max(x, y)
    x > y ? x : y
  end

  def clamp(x, min_v, max_v)
    x.clamp(min_v, max_v)
  end

  def length(x, y)
    sqrt(x * x + y * y)
  end

  def step(edge, x)
    x < edge ? 0.0 : 1.0
  end

  def mix(x, y, a)
    x * (1 - a) + y * a
  end

  def distance(p0, p1)
    $gtk.geometry.distance(p0, p1)
  end

  def normalize(x, y)
    l = length(x, y)
    [x /= l, y /= l]
  end

=begin shadertoy supported commands

Angle and Trigonometry Functions
✔️ type radians (type degrees)
✔️ type degrees (type radians)
✔️ type sin (type angle)
✔️ type cos (type angle)
✔️ type tan (type angle)
✔️ type asin (type x)
✔️ type acos (type x)
??type atan (type y, type x)
??type atan (type y_over_x)
✔️ type sinh (type x)
✔️ type cosh (type x)
✔️ type tanh (type x)
✔️ type asinh (type x)
✔️ type acosh (type x)
✔️ type atanh (type x)

Exponential Functions
✔️ type pow (type x, type y)
✔️ type exp (type x)
  type log (type x) Conflicts with DragonRuby log command
✔️ type exp2 (type x)
✔️ type log2 (type x)
✔️ type sqrt (type x)
✔️ type inversesqrt (type x)

Common Functions
✔️ type abs (type x)
✔️ type sign (type x)
✔️ type floor (type x)
✔️ type ceil (type x)
✔️ type trunc (type x)
✔️  type fract (type x)
✔️ type mod (type x, float y)
  type modf (type x, out type i)
✔️ type min (type x, type y)
✔️ type max (type x, type y)
✔️ type clamp (type x, type minV, type maxV)
✔️ type mix (type x, type y, type a)
✔️ type step (type edge, type x)
  type smoothstep (type a, type b, type x)

Geometric Functions
✔️ float length (type x)
✔️ float distance (type p0, type p1)
  float dot (type x, type y)
  vec3 cross (vec3 x, vec3 y)
✔️  type normalize (type x)
  type faceforward (type N, type I, type Nref)
  type reflect (type I, type N)
  type refract (type I, type N,float eta)
  float determinant(mat? m)
  mat?x? outerProduct(vec? c, vec? r)
  type matrixCompMult (type x, type y)
  type inverse (type inverse)
  type transpose (type inverse)
  vec4 texture( sampler? , vec? coord [, float bias])
  vec4 textureLod( sampler, vec? coord, float lod)
  vec4 textureLodOffset( sampler? sampler, vec? coord, float lod, ivec? offset)
  vec4 textureGrad( sampler? , vec? coord, vec2 dPdx, vec2 dPdy)
  vec4 textureGradOffset sampler? , vec? coord, vec? dPdx, vec? dPdy, vec? offset)
  vec4 textureProj( sampler? , vec? coord [, float bias])
  vec4 textureProjLod( sampler? , vec? coord, float lod)
  vec4 textureProjLodOffset( sampler? , vec? coord, float lod, vec? offset)
  vec4 textureProjGrad( sampler? , vec? coord, vec2 dPdx, vec2 dPdy)
  vec4 texelFetch( sampler? , ivec? coord, int lod)
  vec4 texelFetchOffset( sampler?, ivec? coord, int lod, ivec? offset )
  ivec? textureSize( sampler? , int lod)
  type dFdx (type x)
  type dFdy (type x)
  type fwidth (type p)
  type isnan (type x)
  type isinf (type x)
  float intBitsToFloat (int v)
  uint uintBitsToFloat (uint v)
  int floatBitsToInt (float v)
  uint floatBitsToUint (float v)
  uint packSnorm2x16 (vec2 v)
  uint packUnorm2x16 (vec2 v)
  vec2 unpackSnorm2x16 (uint p)
  vec2 unpackUnorm2x16 (uint p)
  bvec lessThan (type x, type y)
  bvec lessThanEqual (type x, type y)
  bvec greaterThan (type x, type y)
  bvec greaterThanEqual (type x, type y)
  bvec equal (type x, type y)
  bvec notEqual (type x, type y)
  bool any (bvec x)
  bool all (bvec x)
  bvec not (bvec x)
=end

end

class Float
  unless instance_methods.include? :__original_add__
    alias :__original_add__ :+
  end

  unless instance_methods.include? :__original_multiply__
    alias :__original_multiply__ :*
  end

  def +(other)
    if other.is_a? Vec3
      Vec3.new(
        self + other.x,
        self + other.y,
        self + other.z
      )
    else
      __original_add__ other
    end
  end

  def *(other)
    if other.is_a? Vec3
      Vec3.new(
        self * other.x,
        self * other.y,
        self * other.z
      )
    else
      __original_multiply__ other
    end
  end
end

def vec2 *params
  if params[0].is_a? Vec2
    params[0]
  else
    v = $vec2_pool.at($vec2_counter)
    if v.nil?
      v = Vec2.new(*params)
      $vec2_pool << v
    else
      v.x, vy = *params
    end
    $vec2_counter +=1
    v
  end
end

def vec3 *params
  if params[0].is_a? Vec3
    params[0]
  else
    v = $vec3_pool.at($vec3_counter)
    if v.nil?
      v = Vec3.new(*params)
      $vec3_pool << v
    else
      v.x, v.y, v.z = *params
    end
    $vec3_counter +=1
    v
  end
end

def vec4 *params
  if params[0].is_a? Vec4
    params[0]
  else
    v = $vec4_pool.at($vec4_counter)
    if v.nil?
      v = Vec4.new(*params)
      $vec4_pool << v
    else
      if params[0].is_a? Vec3
        v.x = params[0].x
        v.y = params[0].y
        v.z = params[0].z
        v.w = params[1]
      else
        v.x, v.y, v.z, v.w = *params
      end
    end
    $vec4_counter +=1
    v
  end
end

class Vec2
  attr_accessor :x, :y
  def initialize *params
    if params[0].is_a? Vec2
      @x = params[0].x
      @y = params[0].y
    else
      @x, @y = *params
    end
  end

  def xyx
    vec3 @x, @y, @x
  end

  def / other
    vec2(@x / other.x, @y / other.y)
  end

  def serialize
    { x: @x, y: @y }
  end

  def inspect
    "#{serialize}"
  end

  def to_s
    "#{serialize}"
  end
end

class Vec3
  attr_accessor :x, :y, :z
  def initialize *params
    if params.size == 3
      @x, @y, @z = *params
    elsif params.size == 1
      @x = params[0].x
      @y = params[0].y
      @z = params[0].z
    end
  end

  def xy
    vec2 @x, @y
  end

  def + other
    Vec3.new(
      @x + other.x,
      @y + other.y,
      @z + other.z
    )
  end

  def serialize
    { x: @x, y: @y, z: @z }
  end

  def inspect
    "#{serialize}"
  end

  def to_s
    "#{serialize}"
  end
end

class Vec4
  attr_accessor :x, :y, :z, :w

  def initialize *params
    if params[0].is_a? Vec2
      @x = params[0].x
      @y = params[0].y
      if params[1].is_a? Vec2
        @z = params[1].x
        @w = params[1].y
      else
        @z = params[1]
        @w = params[2]
      end
    elsif params[0].is_a? Vec3
      @x = params[0].x
      @y = params[0].y
      @z = params[0].z
      @w = params[1]
    elsif params[0].is_a? Vec4
      @x = params[0].x
      @y = params[0].y
      @z = params[0].z
      @w = params[0].w
    else
      @x, @y, @z, @w = *params
    end
  end

  def serialize
    { x: @x, y: @y, z: @z, w: @w }
  end

  def inspect
    "#{serialize}"
  end

  def to_s
    "#{serialize}"
  end
end