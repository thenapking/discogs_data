class Api::StyleSummariesController < ApplicationController

  def index
    @style_summaries = StyleSummary
      .joins(:style)
      .select('style_summaries.id, styles.name as name, style_summaries.year, style_summaries.count')
      .order('styles.name, style_summaries.year')
    @style_summaries = @style_summaries.where(year: params[:year]) if params[:year]
      
    render json: @style_summaries
  end

  def show
    @style_summary = StyleSummary.find(params[:id])
    render json: @style_summary
  end
end
