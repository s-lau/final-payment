class EventsController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource except: [:comment, :show]

  def comment
    authorize! :create, @event => EventComment
    event = Event.find params[:id]
    text = params[:comment_text]
    
    comment = event.comments.build params[:event_comment] do |ec|
      ec.author = current_user
    end

    if comment.save
      gflash :notice
    else
      gflash :error
    end
    redirect_to event_path(event, anchor: 'comments')
  end

  # GET /events
  # GET /events.json
  def index
    @events = {
      total_number_of_events_in_database: Event.count,
      own_events: EventDecorator.decorate(Event.where(owner: current_user))
    }

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @events }
    end
  end

  # GET /events/1
  # GET /events/1.json
  def show
    @event = EventDecorator.decorate(Event.find(params[:id]))
    @event_charges = EventChargeDecorator.decorate(@event.charges)

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @event }
    end
  end

  # POST /events/1/join
  def join
    participation = @event.event_participations.build do |p|
      p.user = current_user
    end

    if participation.save
      gflash :notice
    else
      gflash :error
    end
    redirect_to @event
  end

  # POST /events/1/leave
  def leave
    destroyed = EventParticipation.where(["user_id = ? AND event_id=?", current_user, @event]).destroy_all
    if destroyed.length > 0 
      gflash :notice
    else
      gflash :error
    end
    redirect_to @event
  end

  #POST /events/1/close
  def close
    @event.update_attributes(:closed => true)
    @event.save
    redirect_to @event
  end

  # GET /events/new
  # GET /events/new.json
  def new
    @event = Event.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @event }
    end
  end

  # GET /events/1/edit
  def edit
    @event = Event.find(params[:id])
  end

  # POST /events
  # POST /events.json
  def create
    @event = Event.new(params[:event])
    @event.owner= current_user

    respond_to do |format|
      if @event.save
        format.html do
          gflash :notice
          redirect_to @event
        end
        format.json { render json: @event, status: :created, location: @event }
      else
        format.html do
          gflash :error
          render action: "new"
        end
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /events/1
  # PUT /events/1.json
  def update
    @event = Event.find(params[:id])

    respond_to do |format|
      if @event.update_attributes(params[:event])
        format.html do
          gflash :notice
          redirect_to @event
        end
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1
  # DELETE /events/1.json
  def destroy
    @event = Event.find(params[:id])
    @event.destroy

    respond_to do |format|
      format.html { redirect_to events_url }
      format.json { head :no_content }
    end
  end
end
