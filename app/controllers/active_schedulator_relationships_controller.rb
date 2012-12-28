class ActiveSchedulatorRelationshipsController < ApplicationController

    def index
        @schedulator = Schedulator.find(params[:schedulator])
        redirect_to @schedulator        
    end

    def create
        $state = "current"
        @schedulator = Schedulator.find(params[:schedulator])
        if !current_or_guest_user.active_schedulators.include?(@schedulator) 
            if !@schedulator.nil?
                current_or_guest_user.active_schedulators << @schedulator
            end
            respond_to do |format|
                format.js
            end
        end
    end

    def destroy
        @activeRelationship = ActiveSchedulatorRelationship.find(params[:id])
        @sid = @activeRelationship.schedulator_id
        @schedulator = Schedulator.find(@sid)
        @name = "Untitled"
        if current_or_guest_user.active_schedulators.include?(@schedulator)
            current_or_guest_user.active_schedulators.delete(@schedulator)            
        end
        @schedulator = current_or_guest_user.current_schedulator
        respond_to do |format|
            format.js
        end
    end

end
