
def mainImage(fragColor, fragCoord)
  # # Normalized pixel coordinates (from 0 to 1)
  # uv = vec2.new(fragCoord/iResolution.xy)
  uv_x = fragCoord.x/iResolution.x
  uv_y = fragCoord.y/iResolution.y

  # # Time varying pixel color
  # col = vec3.new(0.5 + 0.5*cos(iTime+uv.xyx+vec3.new(0,2,4)))
  col_r = 0.5 + 0.5 * cos(iTime + uv_x)
  col_g = 0.5 + 0.5 * cos(iTime + uv_y + 2)
  col_b = 0.5 + 0.5 * cos(iTime + uv_x + 4)

  # # Output to screen
  # $fragColor = vec4.new(col,1.0)
  # puts fragColor.z if x==0 && y==0
  $fragColor.x = col_r
  $fragColor.y = 0.0
  $fragColor.z = 0.0

  puts iTime if $args.tick_count == 0
end

def fragColor
  $fragColor
end

def fragCoord
  $fragCoord
end

def iTime
  $iTime
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
      vec3.new(
        $iTime + other.x,
        $iTime + other.y,
        $iTime + other.z
      )
    else
      __original_add__ other
    end
  end

  def *(other)
    if other.is_a? Vec3
      vec3.new(
        $iTime * other.x,
        $iTime * other.y,
        $iTime * other.z
      )
    else
      __original_multiply__ other
    end
  end
end

def vec2
  Vec2
end

def vec3
  Vec3
end

def vec4
  Vec4
end

def iResolution
  $iResolution
end

class Vec2
  attr_accessor :x, :y
  def initialize *params
    if params.size == 2
      @x, @y = *params
    elsif params.size == 1
      @x = params[0].x
      @y = params[0].y
    end
  end

  def / other
    vec2.new(
      self.x / other.x,
      self.y / other.y
    )
  end

  def xyx
    vec3.new(@x, @y, @x)
  end

  def self.method_missing(m, *args)
    # puts "OHOHOH"
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
    vec2.new(@x, @y)
  end

  def + other
    vec3.new(
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
    if params[0].is_a? Vec3
      @x = params[0].x
      @y = params[0].y
      @z = params[0].z
      @w = params[1]
    else
      @x, @y, @z, @w = *params
    end
  end

  def xyz
    vec3.new(@x, @y, @z)
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


#   void mainImage( out vec4 fragColor, in vec2 fragCoord )
# {
#     // Normalized pixel coordinates (from 0 to 1)
#     vec2 uv = fragCoord/iResolution.xy;

#     // Time varying pixel color
#     vec3 col = 0.5 + 0.5*cos(iTime+uv.xyx+vec3(0,2,4));

#     // Output to screen
#     fragColor = vec4(col,1.0);
# }

# def mainImage(frag)
  # pos_x = (frag.x / $iResolution_x) * 26.0 - 13.0
  # pos_y = (frag.y / $iResolution_y) * 26.0 - 13.0

  # x = sin($iTime + length(pos_x, pos_y)) + cos(($mouse_x * 10.0) + pos_x)
  # y = cos($iTime + length(pos_x, pos_y)) + sin(($mouse_y * 10.0) + pos_y)

  # frag.r = x * 0.5
  # frag.g = y * 0.5
  # frag.b = x * y
  # vec2.name
# end

