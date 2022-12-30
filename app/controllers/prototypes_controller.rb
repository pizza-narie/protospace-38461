class PrototypesController < ApplicationController
  before_action :set_prototype, only: [:show, :update, :edit, :destroy]
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
  before_action :move_to_index, only: [:edit]

  def index
    @prototypes = Prototype.all
  end

  def new
    @prototype = Prototype.new
  end

  def create
    @prototype = Prototype.new(prototype_params)
    if @prototype.save
      redirect_to prototypes_path(@prototype)
    else
      @prototype = Prototype.new(prototype_params)
      render action: :new
   end
  end

  def show
    @comment = Comment.new
    @comments = @prototype.comments.includes(:user)
  end

  def update
    if @prototype.update(prototype_params)
      redirect_to Prototype.find(params[:id])
    else
      @prototype.update(prototype_params)
      render action: :edit
    end
  end
  
  def edit
  end

  def destroy
    @prototype.destroy
    redirect_to prototypes_path(@prototype)
  end

  private

  def prototype_params
    params.require(:prototype).permit(:title, :catch_copy, :concept, :image).merge(user_id: current_user.id)
  end

  def set_prototype
    @prototype = Prototype.find(params[:id])
  end


  def move_to_index
    unless current_user.id == @prototype.user_id
      redirect_to action: :index
    end
  end
end

