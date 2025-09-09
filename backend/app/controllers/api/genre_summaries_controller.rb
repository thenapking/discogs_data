class Api::GenreSummariesController < ApplicationController

  def index
    @genre_summaries = GenreSummary
      .joins(:genre)
      .where.not(year: 0)
      .where.not(genres: {name: "\u0026"})
      .where.not(genres: {name: "1"})
      .where.not(genres: {name: "Military"})
      .where.not(genres: {name: "Non-Music"})
      .where.not(genres: {name: "Screen"})
      .where.not(genres: {name: "Stage"})
      .where.not(genres: {name: "Children"})
      .select('genre_summaries.id, genres.name as name, genre_summaries.year, genre_summaries.count')
      .order('genres.name, genre_summaries.year')
    @genre_summaries = @genre_summaries.where(year: params[:year]) if params[:year]
    
    render json: @genre_summaries
  end

  def show
    @genre_summary = GenreSummary.find(params[:id])
    render json: @genre_summary
  end
end
