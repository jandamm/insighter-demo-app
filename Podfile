platform :ios, '9.0'

source 'https://github.com/CocoaPods/Specs.git'
source 'git@gitlab.com:charmaex/JDPodSpec.git'

target 'insighter' do
  use_frameworks!
  
  pod 'Firebase/Core'
  pod 'Firebase/Auth'
  pod 'Firebase/Database'
  pod 'Firebase/RemoteConfig'
  
  pod 'DropDown'
  pod 'JGProgressHUD'
  pod 'NextResponderTextField', '~> 1.2.0'
  
  pod 'JDTransition'
  pod 'JDCoordinator'

  target 'insighterTests' do
    inherit! :search_paths
    
  end

  target 'insighterUITests' do
    inherit! :search_paths
    
  end

end
