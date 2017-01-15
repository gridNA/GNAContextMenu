Pod::Spec.new do |s|
  s.name             = "GNAContextMenu"
  s.version          = "1.1.0"
  s.summary          = "Long press context menu written in swift"
  s.description      = <<-DESC
                       Long press context menu (like in Pintrest for iOS app)
                       DESC
  s.homepage         = "https://github.com/gridNA/GNAContextMenu"
  s.license          = { :type => "MIT", :file => "License" }
  s.author           = { "KaterynaGridina" => "gridina.kate170890@gmail.com" }
  s.source           = { :git => "https://github.com/gridNA/GNAContextMenu.git", :tag => s.version}
  s.platform     = :ios, '9.0'
  s.requires_arc = true
  s.source_files = 'gnaContextMenu/GNAContextMenu/*.swift'
end
