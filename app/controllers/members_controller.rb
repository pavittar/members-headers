class MembersController < ApplicationController
  before_action :set_member, only: [:show, :update, :destroy]

  # GET /members
  # GET /members.json
  def index
    @members = Member.with_friends_count
  end

  # GET /members/1
  # GET /members/1.json
  def show
    @friendships = Friendship.where('member_id = :id OR friend_id = :id', id: @member).includes(:member, :friend)
  end

  # GET /members/new
  def new
    @member = Member.new
  end

  # GET /members/1/edit
  def edit
    @member = Member.find(params[:id])
    @friendships = Friendship.where('member_id = :id OR friend_id = :id', id: @member).includes(:member, :friend)
    @members = Member.where.not(id:
      @friendships.flat_map { |f| [f.member_id, f.friend_id] }.uniq << @member.id
    )
  end

  # POST /members
  # POST /members.json
  def create
    @member = Member.new(member_params)

    respond_to do |format|
      if @member.save
        ContentExtractorService.call(@member)

        format.html { redirect_to @member, notice: 'Member was successfully created.' }
        format.json { render :show, status: :created, location: @member }
      else
        format.html { render :new }
        format.json { render json: @member.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /members/1
  # PATCH/PUT /members/1.json
  def update
    respond_to do |format|
      if @member.update(member_params)
        ContentExtractorService.call(@member)

        format.html { redirect_to @member, notice: 'Member was successfully updated.' }
        format.json { render :show, status: :ok, location: @member }
      else
        format.html { render :edit }
        format.json { render json: @member.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /members/1
  # DELETE /members/1.json
  def destroy
    @member.destroy
    respond_to do |format|
      format.html { redirect_to members_url, notice: 'Member was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_member
      @member = Member.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def member_params
      params.fetch(:member, {}).permit(:name, :website_url, friend_ids: [])
    end
end