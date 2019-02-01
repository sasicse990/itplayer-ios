# Uncomment the next line to define a global platform for your project
platform :ios, '11.0'

 def shared_pods

  use_frameworks!

    inhibit_all_warnings!

    pod 'IQKeyboardManagerSwift'

end

target 'ITPlayer' do
 
 	shared_pods

end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['GCC_WARN_INHIBIT_ALL_WARNINGS'] = "YES"
        end
    end
    
end
