#--------------------------------------------------------------------------
# Copyright (c) Microsoft Open Technologies, Inc.
# All Rights Reserved.  Licensed under the Apache License, Version 2.0.
# See License.txt in the project root for license information.
#--------------------------------------------------------------------------
require 'log4r'

# Barebones basic implemenation. This a work in progress in very early stages
module VagrantPlugins
  module WinAzure
    module Action
      class StopInstance

        def initialize(app, env)
          @app = app
          @logger = Log4r::Logger.new('vagrant_azure::action::stop_instance')
        end

        def call(env)
          if env[:machine].state.id == :StoppedDeallocated
            @logger.info(
              I18n.t('vagrant_azure.already_status', :status => 'stopped.')
            )
          else
            env[:machine].id =~ /@/
            VagrantPlugins::WinAzure::CLOUD_SERVICE_SEMAPHORE.synchronize do
              @logger.info(
                  I18n.t(
                      'vagrant_azure.stopping',
                      :vm_name => $`,
                      :cloud_service_name => $'
                  )
              )
              env[:azure_vm_service].shutdown_virtual_machine($`, $')
            end
          end
          @app.call(env)
        end
      end
    end
  end
end
