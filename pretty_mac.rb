#! /bin/sh
exec ruby -S -x "$0" "$@"
#! ruby

require 'yaml'
require 'plist'

def sw_info
  out = `sw_vers`
  info = YAML.load(out)
  return info
end

def hw_info
  out = `system_profiler SPHardwareDataType`
  info = YAML.load(out)["Hardware"]["Hardware Overview"]
  return info
end

def machine_name_defs
  return Plist.parse_xml('/System/Library/PrivateFrameworks/ServerInformation.framework/Versions/A/Resources/English.lproj/SIMachineAttributes.plist')
end

sw = sw_info()
sw_desc = sprintf("%s %s (%s)", sw["ProductName"], sw["ProductVersion"], sw["BuildVersion"])

hw = hw_info()
machine_model = machine_name_defs[hw["Model Identifier"]]["_LOCALIZABLE_"]["marketingModel"]
processor_model = sprintf("%s (%s)", hw["Processor Name"], hw["Processor Speed"])
hw_desc = sprintf("%s\n" "Processor: %s\n" "Number of Processors: %d\n" "Total Number of Cores: %d\n" "Memory: %s\n",
                  machine_model,
                  processor_model,
                  hw["Number of Processors"],
                  hw["Total Number of Cores"],
                  hw["Memory"],)
puts sw_desc, hw_desc

__END__
$ ruby pretty_mac.rb

Mac OS X 10.12.6 (16G1212)
13" MacBook Pro with Thunderbolt 3 and Touch ID (Late 2016)
Processor: Intel Core i5 (2.9 GHz)
Number of Processors: 1
Total Number of Cores: 2
Memory: 16 GB
