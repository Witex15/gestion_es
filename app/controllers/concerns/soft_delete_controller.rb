module SoftDeleteController
  extend ActiveSupport::Concern

  # Override the standard index method to only show active records
  def index_with_active_scope
    instance_variable_set("@#{controller_name}", model_class.active)
  end

  # Override the standard destroy method to perform soft delete
  def destroy_with_soft_delete
    @resource = model_class.find(params[:id])
    @resource.destroy
    respond_to do |format|
      format.html { redirect_to url_for(controller: controller_name, action: :index), notice: "#{model_class.name} was successfully deleted." }
      format.json { head :no_content }
    end
  end

  private

  def model_class
    controller_name.classify.constantize
  end
end 