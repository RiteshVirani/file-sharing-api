class UploadFilesController < ApplicationController
  def index
    files = current_user.upload_files
    render json: files
  end

  def create
    file = current_user.upload_files.new(file_params)
    
    if file.save
      render json: { message: "File uploaded successfully", file: file, original_url: file.file.attached? ? { file_id: file.file.blob.id, file_url: url_for(file.file) } : nil }, status: :created
    else
      render json: { errors: file.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    file = current_user.upload_files.find(params[:id])
    
    if file.destroy
      render json: { message: "File deleted successfully" }
    else
      render json: { errors: "Failed to delete file" }, status: :unprocessable_entity
    end
  end

  def show_public
    file = UploadFile.find_by(shared_url: params[:url])
    
    if file.present?
      render json: { file: file, original_url: file.file.attached? ? { file_id: file.file.blob.id, file_url: url_for(file.file) } : nil }
    else
      render json: { error: "File not found" }, status: :not_found
    end
  end

  private

  def file_params
    params.require(:file).permit(:title, :description, :file)
  end
end
