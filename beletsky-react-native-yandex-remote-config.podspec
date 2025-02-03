require "json"

package = JSON.parse(File.read(File.join(__dir__, "package.json")))
folly_compiler_flags = '-DFOLLY_NO_CONFIG -DFOLLY_MOBILE=1 -DFOLLY_USE_LIBCPP=1 -Wno-comma -Wno-shorten-64-to-32'

Pod::Spec.new do |s|
  s.name         = "beletsky-react-native-yandex-remote-config"
  s.version      = package["version"]
  s.summary      = package["description"]
  s.homepage     = package["homepage"]
  s.license      = package["license"]
  s.authors      = package["author"]

  s.platforms    = { :ios => min_ios_version_supported }
  s.source       = { :git => "https://github.com/YBeletsky117/react-native-yandex-remote-config.git", :tag => "#{s.version}" }

  s.source_files = "ios/**/*.{h,m,mm}"

  s.dependency 'Varioqub', '0.7.1'
  s.dependency 'Varioqub/MetricaAdapterReflection', '~> 0.7.1'
  s.dependency 'AppMetricaCore'

  # Use install_modules_dependencies helper to install the dependencies if React Native version >=0.71.0.
  install_modules_dependencies(s)
end
