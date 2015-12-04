MRuby::Build.new do |conf|
  # load specific toolchain settings
  # Gets set by the VS command prompts.
  if ENV['VisualStudioVersion'] || ENV['VSINSTALLDIR']
    toolchain :visualcpp
  else
    toolchain :gcc
  end
  enable_debug
  # include the default GEMs
  conf.gembox 'default'
end

MRuby::CrossBuild.new('i686-w64-mingw32') do |conf|
  toolchain :gcc
  conf.build_target     = 'i686-pc-linux-gnu'
  conf.host_target      = 'i686-w64-mingw32'
  conf.cc do |cc|
    cc.command = "i686-w64-mingw32-gcc"
  end
  conf.cxx.command = 'i686-w64-mingw32-g++'
  conf.linker do |linker|
    linker.command = "i686-w64-mingw32-gcc"
  end
  conf.archiver do |archiver|
    archiver.command = "i686-w64-mingw32-ar"
  end
  conf.exts.executable = ".exe"

  conf.gem :github => 'kjunichi/mruby-webcam'
  conf.gembox 'default'
end

MRuby::CrossBuild.new('x86_64-w64-mingw32') do |conf|
  toolchain :gcc
  conf.build_target     = 'x86_64-pc-linux-gnu'
  conf.host_target      = 'x86_64-w64-mingw32'
  conf.cc do |cc|
    cc.command = "x86_64-w64-mingw32-gcc"
  end
  conf.cxx.command = 'x86_64-w64-mingw32-g++'
  conf.linker do |linker|
    linker.command = "x86_64-w64-mingw32-g++"
  end
  conf.archiver do |archiver|
    archiver.command = "x86_64-w64-mingw32-ar"
  end
  conf.exts.executable = ".exe"

  conf.gem :github => 'kjunichi/mruby-webcam'
  conf.gembox 'default'
end
