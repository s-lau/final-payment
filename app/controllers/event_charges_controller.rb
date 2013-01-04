class EventChargesController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource :event
  load_and_authorize_resource :event_charge, through: :event, through_association: :charges
  
  # GET /event_charges/1/edit
  def edit
    @event_charge = @event.charges.find(params[:id])
  end

  # POST /event_charges
  # POST /event_charges.json
  def create
    @event_charge = @event.charges.new(params[:event_charge])
    @event_charge.user = current_user

    respond_to do |format|
      if @event_charge.save
        format.html do
          gflash :notice
          redirect_to event_path(@event, anchor: 'charges')
        end
        format.json { render json: @event_charge, status: :created, location: @event_charge }
      else
        format.html do
          gflash :error
          render action: "new"
        end
        format.json { render json: @event_charge.errors, status: :unprocessable_entity }
      end
    end
  end
  
  # PUT /event_charges/1
  # PUT /event_charges/1.json
  def update
    @event_charge = @event.charges.find(params[:id])

    respond_to do |format|
      if @event_charge.update_attributes(params[:event_charge])
        format.html do
          gflash :notice
          redirect_to event_path(@event, anchor: 'charges')
        end
        format.json { head :no_content }
      else
        format.html do
          logger.debug @event_charge.errors.full_messages
          gflash :error
          render action: "edit"
        end
        format.json { render json: @event_charge.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /event_charges/1
  # DELETE /event_charges/1.json
  def destroy
    @event_charge = @event.charges.find(params[:id])
    @event_charge.destroy

    respond_to do |format|
      format.html { redirect_to event_path(@event, anchor: 'charges') }
      format.json { head :no_content }
    end
  end
  
end
