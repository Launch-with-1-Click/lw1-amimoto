tztable = {
  "eu-west-1" => "WET",
  "ap-southeast-1" => "Asia/Singapore",
  "ap-southeast-2" => "Australia/Sydney",
  "eu-central-1" => "Europe/Berlin",
  "ap-northeast-2" => "Asia/Seoul",
  "ap-northeast-1" => "Asia/Tokyo",
  "us-east-1" => "US/Eastern",
  "sa-east-1" => "America/Sao_Paulo",
  "us-west-1" => "US/Pacific",
  "us-west-2" => "US/Pacific"
}


default[:ec2][:region] = node[:ec2][:placement_availability_zone].chop


default[:timezone] = tztable[node[:ec2][:region]] || "UTC"

