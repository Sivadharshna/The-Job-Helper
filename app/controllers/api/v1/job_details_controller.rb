module Api
    module V1
        class JobDetailsController < Api::ApplicationController
            before_action :doorkeeper_authorize!
            
            def index
            end

            def create

            end
        end
    end
end

