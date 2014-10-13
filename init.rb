require 'redmine'

Redmine::Plugin.register :redmine_forbidden_attachments do
	name 'Redmine attachments download forbidding plugin'
	description 'A plugin to forbid downloading attachmants with prefix "private_".'
	url 'https://github.com/mephi-ut/redmine_forbidden_attachments'
	author 'Dmitry Yu Okunev'
	author_url 'https://github.com/xaionaro'
	version '0.0.1'

	project_module :private_attachments do
		permission :permit_download_private_attachments, {}
	end
end

require_dependency 'patches/app/controllers/attachments_controller'

