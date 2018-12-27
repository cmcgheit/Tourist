# Uncomment the next line to define a global platform for your project
# platform :ios, '10.0'

target 'Tourist' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Tourist
  pod 'GoogleMaps'
  pod 'GooglePlaces'
  pod 'GooglePlacesAPI'
  pod 'SwiftyJSON'
  pod 'Alamofire'
  pod 'ObjectMapper'
  pod 'Cards'
  pod 'Pulley'
#  pod 'STLocationRequest'

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['CLANG_WARN_DOCUMENTATION_COMMENTS'] = 'NO'
        end
    end
end

#  post_install do |installer|
#      installer.pods_project.targets.each do |target|
#          target.build_configurations.each do |config|
#              config.build_settings['SWIFT_VERSION'] = '4.0'
#          end
#      end
#  end

end
