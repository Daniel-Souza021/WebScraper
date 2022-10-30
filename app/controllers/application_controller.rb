class ApplicationController < ActionController::Base

  before_action :filtros_sessao

  def filtros_sessao
    if session
      session[:filtros] ||= {}
      session[:filtros][:"#{params[:controller]}##{params[:action]}"] = params["produto"]["descricao"] if params.has_key? "produto"
    end

  end
end
