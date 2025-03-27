class DeletedObjectsController < ApplicationController
  before_action :authorize_dean
  
  def index
    @model_classes = find_soft_deletable_models
    @selected_model = params[:model].present? ? params[:model].constantize : nil
    
    @deleted_objects = if @selected_model
                         @selected_model.unscoped.where.not(deleted_at: nil).order(deleted_at: :desc)
                       else
                         []
                       end
  end
  
  def restore
    model_class = params[:model].constantize
    @resource = model_class.unscoped.find(params[:id])
    
    if @resource.restore
      redirect_to deleted_objects_path(model: params[:model]), notice: "#{model_class.name} was successfully restored."
    else
      redirect_to deleted_objects_path(model: params[:model]), alert: "Failed to restore #{model_class.name}."
    end
  end
  
  def restore_all
    model_class = params[:model].constantize
    deleted_records = model_class.unscoped.where.not(deleted_at: nil)
    count = deleted_records.count
    
    if count > 0
      # Restore all deleted records
      deleted_records.each(&:restore)
      redirect_to deleted_objects_path(model: params[:model]), notice: "Successfully restored #{count} #{model_class.name.pluralize}."
    else
      redirect_to deleted_objects_path(model: params[:model]), alert: "No deleted #{model_class.name.pluralize} to restore."
    end
  end
  
  private
  
  def authorize_dean
    redirect_to root_path, alert: "You are not authorized to access this page." unless current_person&.dean?
  end
  
  def find_soft_deletable_models
    ApplicationRecord.descendants.select do |model|
      model.included_modules.include?(SoftDeletable) && 
      model.column_names.include?("deleted_at") &&
      model.unscoped.where.not(deleted_at: nil).exists?
    end
  end
end 