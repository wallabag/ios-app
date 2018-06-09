source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '10.0'
use_frameworks!

target 'wallabag' do
    pod 'Alamofire', '~> 4.5'
    pod 'AlamofireImage', '~> 3.3'
    pod 'AlamofireNetworkActivityIndicator', '~> 2.2'
    pod 'TUSafariActivity', '~> 1.0'
    pod 'SideMenu', '~> 3.1'
    pod 'RealmSwift'
    pod 'GoogleAnalytics'
    
    target 'wallabagUITests' do
        inherit! :search_paths
        pod 'Mockingjay'
    end

    target 'wallabagTests' do
        inherit! :search_paths
        pod 'Mockingjay'
    end
end

target 'bagit' do
    pod 'Alamofire', '~> 4.5'
end



post_install do |installer|
    myTargets = ['SideMenu']

    installer.pods_project.targets.each do |target|
        if myTargets.include? target.name
            target.build_configurations.each do |config|
                config.build_settings['SWIFT_VERSION'] = '3.2'
            end
        end
    end
end
