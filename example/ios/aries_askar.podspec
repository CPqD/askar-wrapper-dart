Pod::Spec.new do |s|
  s.name             = 'aries_askar'
  s.version          = '0.0.1'
  s.summary          = 'example plugin'
  s.description      = <<-DESC
A new flutter plugin project.
                       DESC
  s.homepage         = 'https://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'a' => 'abc@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.platform = :ios, '14.0'
  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
  s.preserve_paths = 'aries_askar.xcframework'
  s.xcconfig = { 'OTHER_LDFLAGS' => '-framework aries_askar' }
  s.vendored_frameworks = 'aries_askar.xcframework'
end

