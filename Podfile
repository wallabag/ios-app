source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '10.0'
use_frameworks!


target 'wallabag' do
    pod 'Alamofire', '~> 4.0'
    pod 'TUSafariActivity', '~> 1.0'
    pod 'AlamofireNetworkActivityIndicator', '~> 2.0'
    pod 'WallabagKit', :path => '../WallabagKit'

    target 'wallabagTests' do
        inherit! :search_paths
        # Pods for testing
    end

    target 'wallabagUITests' do
        inherit! :search_paths
        # Pods for testing
    end

    target 'bagit' do
        inherit! :search_paths
    end
    
end
