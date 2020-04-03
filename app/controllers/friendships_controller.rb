class FriendshipsController < ApplicationController
  before_action :set_member, only: [:create, :destroy]

  # POST /friendships
  # POST /friendships.json
  def create
    @friendship = @member.friendships.build(friend_id: params[:friend_id])

    respond_to do |format|
      if @friendship.save
        format.html { redirect_to @member, notice: 'Friendship was successfully created.' }
        format.json { render :show, status: :created, location: @member }
      else
        format.html { redirect_to @member, notice: 'Friendship failed.' }
        format.json { render json: @member.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /friendships/1
  # DELETE /friendships/1.json
  def destroy
    @friendship = Friendship.find(params[:id])
    @friendship.destroy

    respond_to do |format|
      format.html { redirect_to @member, notice: 'Friendship was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_member
      @member = Member.find(params[:member_id])
    end
end
