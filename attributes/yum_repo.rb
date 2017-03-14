default[:yum][:repo][:amimoto_repo] = true
default[:yum][:repo][:remi][:php][:mirrorlist] = 'http://rpms.famillecollet.com/enterprise/6/remi/mirror'
default[:yum][:repo][:remi][:php][:baseurl] = 'http://rpms.famillecollet.com/enterprise/6/remi/$basearch/'
default[:yum][:repo][:remi][:php55][:mirrorlist] = 'http://rpms.famillecollet.com/enterprise/6/php55/mirror'
default[:yum][:repo][:remi][:php55][:baseurl] = 'http://rpms.famillecollet.com/enterprise/6/php55/$basearch/'
default[:yum][:repo][:remi][:php56][:mirrorlist] = 'http://rpms.famillecollet.com/enterprise/6/php56/mirror'
default[:yum][:repo][:remi][:php56][:baseurl] = 'http://rpms.famillecollet.com/enterprise/6/php56/$basearch/'
default[:yum][:repo][:remi][:php70][:mirrorlist] = 'http://rpms.famillecollet.com/enterprise/6/php70/mirror'
default[:yum][:repo][:remi][:php70][:baseurl] = 'http://rpms.famillecollet.com/enterprise/6/php70/$basearch/'
default[:yum][:repo][:remi][:php71][:mirrorlist] = 'http://rpms.famillecollet.com/enterprise/6/php71/mirror'
default[:yum][:repo][:remi][:php71][:baseurl] = 'http://rpms.famillecollet.com/enterprise/6/php71/$basearch/'
default[:yum][:repo][:nginx][:baseurl] = 'https://packagecloud.io/amimoto-nginx-mainline/main/el/6/$basearch'
default[:yum][:repo][:percona][:baseurl] = 'http://repo.percona.com/centos/6Server/os/$basearch/'

if node[:yum][:repo][:amimoto_repo]
  default[:yum][:repo][:remi][:php][:baseurl] = 'http://repos.amimoto-ami.com/enterprise/6/remi/x86_64/'
  default[:yum][:repo][:remi][:php55][:baseurl] = 'http://repos.amimoto-ami.com/enterprise/6/remi-php55/x86_64/'
  default[:yum][:repo][:remi][:php56][:baseurl] = 'http://repos.amimoto-ami.com/enterprise/6/remi-php56/x86_64/'
  default[:yum][:repo][:remi][:php70][:baseurl] = 'http://repos.amimoto-ami.com/enterprise/6/remi-php70/x86_64/'
  default[:yum][:repo][:remi][:php71][:baseurl] = 'http://repos.amimoto-ami.com/enterprise/6/remi-php71/x86_64/'
  default[:yum][:repo][:nginx][:baseurl] = 'http://repos.amimoto-ami.com/enterprise/6/amimoto-nginx-mainline/x86_64/'
  default[:yum][:repo][:percona][:baseurl] = 'http://repos.amimoto-ami.com/enterprise/6/percona/x86_64/'
end
