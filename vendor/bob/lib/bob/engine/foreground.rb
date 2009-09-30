module Bob
  module Engine
    # Dummy engine that just runs in the foreground (useful for tests).
    Foreground = lambda {|b| b.call }
  end
end
