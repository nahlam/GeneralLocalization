#
# Be sure to run `pod lib lint GeneralLocalization.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name         = 'GeneralLocalization'
  s.version      = '2.0.0'
  s.summary      = 'Managing Localization between English & Arabic.'
  s.homepage     = 'https://github.com/nahlam/GeneralLocalization'
  s.description  = 'Managing Localization between English & Arabic to be used in all projects. It is all about getting strings localized from default localization file or even from custom localization file name. also have date localization and numbers localization.'
  
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author       = { 'Nahla Mortad' => 'nahla.mortada@gmail.com' }
  s.platform     = :ios, '9.0'
  s.requires_arc = true
  s.ios.deployment_target = '9.0'
  s.source   = {:git => 'https://github.com/nahlam/GeneralLocalization.git', :tag => s.version}
  s.source_files = 'GeneralLocalization/Classes/**/*'
  s.swift_version = '4.2'
end
