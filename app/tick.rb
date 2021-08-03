include Shader

def tick args
  if args.tick_count.zero?
    Shader.setup(args, 80, 45, 10) # w, h, scale
  end

  Shader.shader_tick(args)
  args.outputs.debug << args.gtk.framerate_diagnostics_primitives

  # if args.tick_count < 600
  #   args.outputs.screenshots << [0, 0, 400, 225, "shots/shader4_#{args.tick_count}.png", 0, 0, 0, 0]
  # end

  # exit if args.tick_count > 0
end