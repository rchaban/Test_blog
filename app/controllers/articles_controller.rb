class ArticlesController < ApplicationController
  before_action :signed_in_user
  before_action :correct_user,   only: [:edit, :update, :destroy]


  def index
  	@articles = Article.all
  end	

  def show
  	@article = Article.find(params[:id])
  end	

  def new
  	@article = Article.new
  end

  def edit
    @article = Article.find(params[:id])
  end	
  
  def create
  	@article = Article.new(article_params)

  	if @article.save
  	  redirect_to @article
  	else
  	  render 'new'
  	end    
  end

  def update
  	@article = Article.find(params[:id])
 
  	if @article.update(article_params)
      redirect_to @article
  	else
      render 'edit'
    end
  end

  def destroy
    @article = Article.find(params[:id])
    @article.destroy
 
    redirect_to articles_path
  end	

  private

    def signed_in_user
      redirect_to signin_url, notice: "Please sign in." unless signed_in?
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(articles_path) unless current_user?(@user)
    end

  	def article_params
  	  params.require(:article).permit(:title, :text)	
  	end  
end
