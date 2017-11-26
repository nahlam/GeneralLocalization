#
#  Be sure to run `pod spec lint GeneralLocalization.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  s.name         = 'GeneralLocalization'
  s.version      = '1.0.0'
  s.summary      = 'Managing Localization between English & Arabic.'
  s.homepage     = 'https://github.com/nahlam/GeneralLocalization'
  s.description  = 'Managing Localization between English & Arabic to be used in all projects. It is all about getting strings localized from default localization file or even from custom localization file name. also have date localization and numbers localization.'
  s.license      = "Simplified BSD license"
  s.author       = { "Nahla Mortada" => "nahla.mortada@gmail.com" }
  s.platform     = :ios, '9.0'
  s.requires_arc = true
  s.ios.deployment_target = '9.0'
  s.source   = { :git => "https://github.com/nahlam/GeneralLocalization.git", :tag => s.version }
  s.source_files = "GeneralLocalization/*"
  s.pod_target_xcconfig = { 'SWIFT_VERSION' => '4.0' }
end


