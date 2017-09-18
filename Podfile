source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '10.0'
use_frameworks!

target 'wallabag' do
    pod 'Alamofire', '~> 4.0'
    pod 'AlamofireImage', '~> 3.1'
    pod 'TUSafariActivity', '~> 1.0'
    pod 'AlamofireNetworkActivityIndicator', '~> 2.0'
    pod 'WallabagKit'
    #pod 'WallabagKit', :path => "../WallabagKit"
    pod 'SideMenu'
    pod 'SwiftyBeaver'

    target 'wallabagUITests' do
        inherit! :search_paths
        # Pods for testing
    end
end

target 'bagit' do
    pod 'WallabagKit'
    #pod 'WallabagKit', :path => "../WallabagKit"
end

target 'wallabagTests' do
    pod 'WallabagKit'
    #pod 'WallabagKit', :path => "../WallabagKit"
end

post_install do |installer|
    # Your list of targets here.
    myTargets = ['SideMenu']

    installer.pods_project.targets.each do |target|
        if myTargets.include? target.name
            target.build_configurations.each do |config|
                config.build_settings['SWIFT_VERSION'] = '3.2'
            end
        end
    end
end
