source 'https://github.com/CocoaPods/Specs.git'

inhibit_all_warnings!

def common_pods
    pod 'PKHUD', '~> 5.0'
    pod 'Alamofire', '~> 4.0'
    pod 'Kingfisher'
    pod 'ObjectMapper'
end

def common_test_pods
    pod 'Nimble'
    pod 'Quick'
end

target 'TopGames' do
    platform :ios, '9.1'
    
    use_frameworks!
    
    common_pods
end

target 'TopGamesTests' do
    platform :ios, '9.1'
    
    use_frameworks!
    
    common_pods
    
    common_test_pods
end
