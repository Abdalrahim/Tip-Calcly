# Uncomment this line to define a global platform for your project
platform :ios, ’10.0’

target 'Tip Calcly' do
  # Comment this line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Tip Calcly
  pod 'IHKeyboardAvoiding'
  pod 'SwiftyJSON'
  pod ‘Mixpanel’
  pod ‘Alamofire’
  pod ‘AlamofireImage’
  pod ‘AlamofireNetworkActivityIndicator’
  use_frameworks!
  pod "TextFieldEffects"

  post_install do |installer|
  installer.pods_project.targets.each do |target|
   target.build_configurations.each do |configuration|
     configuration.build_settings['SWIFT_VERSION'] = “3.0”
   end   
  end
end

end