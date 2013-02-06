class EventsController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource except: [:comment, :show, :join_qr_code, :trash, :recover]

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
  # TODO Keep controllers thin?
  def index
    @events = {
      total_number_events: Event.count,
      total_number_charges: EventCharge.count,
      total_cents_charges: EventCharge.total,
      own_events: EventDecorator.decorate(Event.active.where(owner: current_user)),
      joined_events: current_user.joined_events.active,
      trashed_events: current_user.events.trashed
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
    @event_audits = {
      new: @event.owned_audits.where(["created_at >= ?", current_user.last_sign_in_at]),
      old: @event.owned_audits.where(["created_at < ?", current_user.last_sign_in_at])
    } if @event.owned_audits.present?

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @event }
    end
  end

  # GET /events/1/j/:token
  def join
    if current_user.participates? @event
      gflash :already_joined
      redirect_to @event
      return
    end
    if @event.join_token == params[:token]
      participation = @event.event_participations.build do |p|
        p.user = current_user
      end

      if participation.save
        gflash :notice
      else
        gflash :error
      end
    else
      gflash :error
    end
    redirect_to @event
  end

  def join_qr_code
    @event = Event.find params[:id]
    authorize! :update, @event
    url = join_event_url @event, token: @event.join_token
    respond_to do |format|
      format.svg  { render :qrcode => url }
      format.png  { render :qrcode => url }
      format.gif  { render :qrcode => url }
      format.jpeg { render :qrcode => url }
    end
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
    if @event.owner == current_user and @event.close
      @event.compensate current_user
      gflash :notice
      EventMailer.event_closed_mail(current_user, @event).deliver
    else
      gflash :error
    end
    redirect_to @event
  end

  def compensate
    if current_user == @event.owner
      user = User.find(params[:user])
      @event.compensate user
      gflash :notice
    else
      if @event.participants.include? current_user
        @event.compensate current_user
      else
        gflash :error
      end
    end
    redirect_to @event
  end
  def compensate_all
    if @event.owner ==  current_user and @event.compensate_all
      gflash :notice
    else
      gflash :error
    end
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

  def trash
    event = Event.find(params[:id])
    event.trash
    gflash :notice
    redirect_to action: :index
  end

  def recover
    event = Event.find(params[:id])
    event.recover
    gflash :notice
    redirect_to event
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
