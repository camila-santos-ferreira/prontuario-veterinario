class AnimaisController < ApplicationController
  before_action :set_animal, only: [:edit, :update, :destroy, :activation_animal]

  def index
    @animais = current_user
               .animais
               .includes(:especie, :recinto, :historicos_animal)
               .por_identificador(params[:identificador].to_s)
               .por_especie(params[:especie_id].to_s)
               .por_genero(params[:genero].to_s)
               .por_recinto(params[:recinto_id].to_s)
               .por_status(params[:status].to_s)
               .order(:identificador)
               
  end

  def new
    @animal = current_user.animais.new
  end

  def edit
  end

  def update
    respond_to do |format|
      if @animal.update(animal_params)
        redirect_to animais_path
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace("remote_modal", partial: "animais/modal", locals: { animal: @animal }) }
      end
    end
  end

  def create
    @animal = current_user.animais.new(animal_params)

    respond_to do |format|
      if @animal.save
        redirect_to animais_path
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace("remote_modal", partial: "animais/modal", locals: { animal: @animal }) }
      end
    end
  end

  def destroy
    respond_to do |format|
      if @animal.destroy
        format.turbo_stream { render turbo_stream: turbo_stream.remove("animal-#{@animal.id}") }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace("error", partial: "shared/error", locals: { error: @animal.errors.full_messages.join(", ") }) }
      end
    end
  end

  def activation_animal
    ativo = trata_boolean(params[:ativo])

    respond_to do |format|
      if @animal.update(ativo: ativo)
        redirect_to animais_path
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace("error", partial: "shared/error", locals: { error: "Ocorreu um erro ao atualizar o animal." }) }
      end
    end
  end

  private

  def set_animal
    @animal = current_user.animais.find(params[:id])
  end

  def animal_params
    params.require(:animal).permit(:identificador, :especie_id, :genero, :recinto_id, :ativo)
  end

  def trata_boolean(string)
    ActiveRecord::Type::Boolean.new.cast(string)
  end
end