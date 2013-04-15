class HistoryEntriesController < ApplicationController
  skip_before_filter :authorize

  # GET /history_entries
  # GET /history_entries.json
  def index
    @history_entries = HistoryEntry.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @history_entries }
    end
  end

  # GET /history_entries/1
  # GET /history_entries/1.json
  def show
    @history_entry = HistoryEntry.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @history_entry }
    end
  end

  # GET /history_entries/new
  # GET /history_entries/new.json
  def new
    @history_entry = HistoryEntry.new(params[:word], params[:guessed])

    respond_to do |format|
      format.html redirect_to :game_path, notice: "Your history has been saved!"
    end
  end

  # GET /history_entries/1/edit
  def edit
    @history_entry = HistoryEntry.find(params[:id])
  end

  # POST /history_entries
  # POST /history_entries.json
  def create
    @history_entry = HistoryEntry.new(params[:history_entry])

    respond_to do |format|
      if @history_entry.save
        format.html { redirect_to @history_entry, notice: 'History entry was successfully created.' }
        format.json { render json: @history_entry, status: :created, location: @history_entry }
      else
        format.html { render action: "new" }
        format.json { render json: @history_entry.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /history_entries/1
  # PUT /history_entries/1.json
  def update
    @history_entry = HistoryEntry.find(params[:id])

    respond_to do |format|
      if @history_entry.update_attributes(params[:history_entry])
        format.html { redirect_to @history_entry, notice: 'History entry was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @history_entry.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /history_entries/1
  # DELETE /history_entries/1.json
  def destroy
    @history_entry = HistoryEntry.find(params[:id])
    @history_entry.destroy

    respond_to do |format|
      format.html { redirect_to history_entries_url }
      format.json { head :no_content }
    end
  end
end
