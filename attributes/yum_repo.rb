default[:yum][:repo][:amimoto_repo] = false
default[:yum][:repo][:remi][:php][:mirrorlist] = 'http://rpms.famillecollet.com/enterprise/6/remi/mirror'
default[:yum][:repo][:remi][:php][:baseurl] = 'http://rpms.famillecollet.com/enterprise/6/remi/$basearch/'
default[:yum][:repo][:remi][:php55][:mirrorlist] = 'http://rpms.famillecollet.com/enterprise/6/php55/mirror'
default[:yum][:repo][:remi][:php55][:baseurl] = 'http://rpms.famillecollet.com/enterprise/6/php55/$basearch/'
default[:yum][:repo][:remi][:php56][:mirrorlist] = 'http://rpms.famillecollet.com/enterprise/6/php56/mirror'
default[:yum][:repo][:remi][:php56][:baseurl] = 'http://rpms.famillecollet.com/enterprise/6/php56/$basearch/'
default[:yum][:repo][:remi][:php70][:mirrorlist] = 'http://rpms.famillecollet.com/enterprise/6/php70/mirror'
default[:yum][:repo][:remi][:php70][:baseurl] = 'http://rpms.famillecollet.com/enterprise/6/php70/$basearch/'
default[:yum][:repo][:nginx][:baseurl] = 'https://packagecloud.io/amimoto-nginx-mainline/main/el/6/$basearch'

if node[:yum][:repo][:amimoto_repo]
  default[:yum][:repo][:remi][:php][:baseurl] = 'http://repos.amimoto-ami.com/enterprise/6/remi/x86_64/'
  default[:yum][:repo][:remi][:php55][:baseurl] = 'http://repos.amimoto-ami.com/enterprise/6/remi-php55/x86_64/'
  default[:yum][:repo][:remi][:php56][:baseurl] = 'http://repos.amimoto-ami.com/enterprise/6/remi-php56/x86_64/'
  default[:yum][:repo][:remi][:php70][:baseurl] = 'http://repos.amimoto-ami.com/enterprise/6/remi-php70/x86_64/'
  default[:yum][:repo][:nginx][:baseurl] = 'http://repos.amimoto-ami.com/enterprise/6/amimoto-nginx-mainline/$basearch'
end
