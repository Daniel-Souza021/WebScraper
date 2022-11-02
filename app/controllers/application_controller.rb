class ApplicationController < ActionController::Base

  before_action :filtros_sessao, except: :historico

  def filtros_sessao
    if session
      session[:filtros] ||= {}
      session[:filtros][:"#{params[:controller]}##{params[:action]}"] = params.dig(:filtros,:descricao).to_s if params[:filtros].present?
    end

  end
end
