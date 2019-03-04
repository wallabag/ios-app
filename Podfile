source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '10.0'
use_frameworks!

target 'wallabag' do
    inherit! :search_paths
    pod 'Alamofire', '~> 4.7'
    pod 'AlamofireImage', '~> 3.4'
    pod 'AlamofireNetworkActivityIndicator', '~> 2.2'
    pod 'TUSafariActivity', '~> 1.0'
    pod 'SideMenu'
    pod 'RealmSwift'
    pod 'GoogleAnalytics'
    pod 'Fabric'
    pod 'Crashlytics'
    pod 'Swinject'
    pod 'SwinjectStoryboard'
    
    target 'wallabagUITests' do
       inherit! :search_paths
    end
    target 'wallabagTests' do
        inherit! :search_paths
        pod 'Mockingjay'
    end
end

target 'WallabagKit' do
    inherit! :search_paths
    pod 'Alamofire', '~> 4.7'
end

target 'bagit' do
    pod 'Alamofire', '~> 4.7'
end

post_install do |installer|
    myTargets = ['SideMenu']
    
    installer.pods_project.targets.each do |target|
        if myTargets.include? target.name
            target.build_configurations.each do |config|
                config.build_settings['SWIFT_VERSION'] = '4.2'
            end
        else
            target.build_configurations.each do |config|
                config.build_settings['SWIFT_VERSION'] = '4.1'
            end
        end
    end
end
