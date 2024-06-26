class Animal < ApplicationRecord
  has_paper_trail on: [:create, :update]

  extend Enumerize

  belongs_to :especie
  belongs_to :recinto
  belongs_to :user
  has_many :historicos_animal, class_name: "HistoricoAnimal", dependent: :destroy

  validates :identificador, presence: true
  validates :identificador, uniqueness: { scope: :user_id }
  validates :genero, presence: true

  before_save -> { self.status = :triagem if status.blank? }

  enumerize :genero, in: { macho: 1, femea: 2  }, i18n_scope: "animais_genero", scope: true
  enumerize :status, in: { triagem: 1, em_reabilitacao: 2, aguardando_soltura: 3, soltura: 4, obito: 5 }, i18n_scope: "animais_status", scope: true

  scope :ativos, ->(ativo) { where(ativo: ativo) }
  scope :por_identificador, ->(identificador) { where("identificador ILIKE ?", "%#{identificador}%") if identificador.present? }
  scope :por_especie, ->(especie_id) { where(especie_id: especie_id) if especie_id.present? }
  scope :por_genero, ->(genero) { where(genero: genero) if genero.present? }
  scope :por_recinto, ->(recinto_id) { where(recinto_id: recinto_id) if recinto_id.present? }
  scope :por_status, ->(status) { where(status: status) if status.present? }
end