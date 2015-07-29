class KeywordsController < ApplicationController

  # def index
  # 	render json: Keyword.all.to_json
  # end

  def get_data
  		render json: Keyword.all.to_json
  end

  def add
    @key = Keyword.new({:keyword => "#{params[:keyword].strip}"}) 
    @key.save!
    render json: Keyword.all.to_json
  end

  def delete
  	 @key = Keyword.find("#{params[:id]}")
    @key.destroy
    render json: Keyword.all.to_json
  end
end
