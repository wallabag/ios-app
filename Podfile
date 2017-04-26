source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '10.0'
use_frameworks!

target 'wallabag' do
    pod 'Alamofire', '~> 4.0'
    pod 'AlamofireImage', '~> 3.1'
    pod 'TUSafariActivity', '~> 1.0'
    pod 'AlamofireNetworkActivityIndicator', '~> 2.0'
    pod 'WallabagKit'
    pod 'SideMenu'

    target 'wallabagUITests' do
        inherit! :search_paths
        # Pods for testing
    end
end

target 'bagit' do
    pod 'WallabagKit'
end

target 'wallabagTests' do
    pod 'WallabagKit'
end
