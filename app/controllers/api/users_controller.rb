class Api::UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  # GET /users
  # GET /users.json
  def index
    puts params
    if params[:phone]
      
      if @user = User.find_by(phone: params[:phone])
        render json:@user
      else
        @user = User.new(phone: params[:phone], token: params[:token])
        render json:@user
      end
        @user.save!
    else
      @users = User.all
      render json: @users  
    end
  end


  # GET /users/1
  # GET /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    #check for json
    if params.include? "somePhoneContacts"
      somePhoneNumbersHash = params["somePhoneContacts"]
      somePhoneNumbers = []
      for numberHash in somePhoneNumbersHash
        somePhoneNumbers.push(numberHash["phone"].split(//).last(10).join)
      end
      existingUsers = User.where(phone: somePhoneNumbers)
      someUsers = []
      for user in existingUsers
        someUsers.push(user.phone)
      end
      render json: someUsers
      return
    end
    
    #
    @user = User.find_by(token: params[:user][:token])
    if @user
      @user.phone = params[:user][:phone]
    else
      @user = User.new(token: params[:user][:token], phone: params[:user][:phone])
    end
    @user.create_endpoint_arn
    @user.name = params[:user][:fullName]
    @user.save!
    puts json: @user 
    render json: @user 
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:name, :email, :phone, :verified, :token)
    end
end
