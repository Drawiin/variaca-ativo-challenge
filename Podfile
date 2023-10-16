# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'
flutter_application_path = './my_flutter'
load File.join(flutter_application_path, '.ios', 'Flutter', 'podhelper.rb')

target 'FinancesInfo' do
  install_all_flutter_pods(flutter_application_path)


  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for FinancesInfo
  target 'FinancesInfoTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'FinancesInfoUITests' do
    # Pods for testing
  end


  post_install do |installer|
    flutter_post_install(installer) if defined?(flutter_post_install)
  end
end

