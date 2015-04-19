#--------------------------------------------------------------------------
# Copyright (c) Microsoft Open Technologies, Inc.
# All Rights Reserved.  Licensed under the Apache License, Version 2.0.
# See License.txt in the project root for license information.
#--------------------------------------------------------------------------
require 'log4r'
require 'timeout'

module VagrantPlugins
  module WinAzure
    module Action
      class WaitForCommunicate
        def initialize(app, env)
          @app = app
          @logger = Log4r::Logger.new('vagrant_azure::action::wait_for_communicate')
        end

        def call(env)

          if !env[:interrupted]
              # Wait for SSH to be ready.
              @logger.info(I18n.t('vagrant_azure.waiting_for_comm'))
              while true
                # If we're interrupted then just back out
                break if env[:interrupted]
                break if env[:machine].communicate.ready?
                sleep 5
              end

            # Ready and booted!
            @logger.info(I18n.t('vagrant_azure.comm_ready'))
          end

          @app.call(env)
        end
      end
    end
  end
end
