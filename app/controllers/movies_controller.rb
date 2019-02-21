class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end


  def index
    @all_ratings = Movie.uniq.pluck(:rating)
    @chosen_ratings = []

		if params.key?(:sort)
			session[:sort] = params[:sort]
		elsif session.key?(:sort)
			params[:sort] = session[:sort]
			redirect_to movies_path(params) and return
		end
		
#		@hilite = sort_by = session[:sort_by]

		if params.key?(:ratings)
			session[:ratings] = params[:ratings]
		elsif session.key?(:ratings)
			params[:ratings] = session[:ratings]
			redirect_to movies_path(params) and return
		end
    session[:ratings].each {|key, value| @chosen_ratings << key}
    @movies = Movie.where(["rating IN (?)", @chosen_ratings])
    @movies = @movies.order(session[:sort])
    
  end

=begin
  def index
    @all_ratings = Movie.uniq.pluck(:rating)
    #@all_ratings = Movie.select(:rating).distinct
    @chosen_ratings = []
    if params[:ratings]
      params[:ratings].each {|key, value| @chosen_ratings << key}
      @movies = Movie.where(["rating IN (?)", @chosen_ratings])

    elsif request.original_url =~ /title/
      @movies = Movie.order('title')
    elsif request.original_url =~ /release/
      @movies = Movie.order('release_date')
    else
      @movies = Movie.all
      @chosen_ratings = Movie.uniq.pluck(:rating)
    end
  end
=end

=begin
  def index
    if request.original_url =~ /title/
      @movies = Movie.order('title')
    elsif request.original_url =~ /release/
      @movies = Movie.order('release_date')
    else
      @movies = Movie.all
    end
  end
=end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
