class Api::GenreSummariesController < ApplicationController

  def index
    @genre_summaries = GenreSummary.all
    @genre_summaries = @genre_summaries.where(year: params[:year]) if params[:year]
    
    render json: @genre_summaries
  end

  def show
    @genre_summary = GenreSummary.find(params[:id])
    render json: @genre_summary
  end
end
