# encoding: utf-8

module ForbiddenAttachmentsPlugin
	module AttachmentsControllerPatch
		unloadable
		def self.included(base)
			base.extend(ClassMethods)
			base.send(:include, InstanceMethods)
			base.class_eval do
				alias_method_chain :show,      :forbidden_attachments
				alias_method_chain :thumbnail, :forbidden_attachments
				alias_method_chain :download,  :forbidden_attachments
			end
		end

		module ClassMethods
		end

		module InstanceMethods 
			def is_private?
				return @attachment.filename.index('private_') == 0
			end

			def check_for_privatness
				unless @project.module_enabled?("private_attachments")
					return TRUE
				end

				unless is_private?
					return TRUE
				end

				if User.current.allowed_to?(:permit_download_private_attachments, @project)
					return TRUE
				end

				render_403
				return FALSE
			end

			def show_with_forbidden_attachments
				if check_for_privatness
					show_without_forbidden_attachments
				end
			end
			def thumbnail_with_forbidden_attachments
				if check_for_privatness
					thumbnail_without_forbidden_attachments
				end
			end
			def download_with_forbidden_attachments
				if check_for_privatness
					download_without_forbidden_attachments
				end
			end
		end
	end
end

require_dependency 'attachments_controller'
AttachmentsController.send(:include,  ForbiddenAttachmentsPlugin::AttachmentsControllerPatch)
