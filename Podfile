source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '10.0'
use_frameworks!

target 'wallabag' do
    inherit! :search_paths
    pod 'Alamofire'
    pod 'AlamofireImage'
    pod 'AlamofireNetworkActivityIndicator'
    pod 'TUSafariActivity'
    pod 'SideMenu'
    pod 'RealmSwift'
    pod 'Fabric'
    pod 'Crashlytics'
    pod 'Swinject'
    pod 'SwinjectStoryboard'
    pod 'WallabagKit', :path => '../WallabagKit'
    
    
    target 'wallabagTests' do
        inherit! :search_paths
        pod 'Mockingjay'
    end
end

target 'wallabagUITests' do
  inherit! :search_paths
end

target 'WallabagKit' do
    inherit! :search_paths
    pod 'Alamofire'
end

target 'bagit' do
    pod 'Alamofire'
end

post_install do |installer|
    myTargets = ['URITemplate']
    
    installer.pods_project.targets.each do |target|
        if myTargets.include? target.name
            target.build_configurations.each do |config|
                config.build_settings['SWIFT_VERSION'] = '4.2'
            end
        else
            target.build_configurations.each do |config|
                config.build_settings['SWIFT_VERSION'] = '5.0'
            end
        end
    end
end
