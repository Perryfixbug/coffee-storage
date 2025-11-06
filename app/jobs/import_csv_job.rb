require "csv"

class ImportCsvJob < ApplicationJob
  queue_as :imports

  def perform(file_path, user_id, type)
    model = type.constantize
    valid_columns = model.column_names.map(&:to_sym)

    CSV.foreach(file_path, headers: true) do |row|
      begin
        attrs = row.to_h.transform_keys do |k|
          k.to_s.strip.downcase.gsub(/\A\uFEFF/, "").to_sym
        end

        filtered_attrs = attrs.slice(*valid_columns)
        model.create!(filtered_attrs)
      rescue => e
        Rails.logger.error("Import lỗi: #{e.message}")
      end
    end

    # Dọn file tạm sau khi xong
    File.delete(file_path) if File.exist?(file_path)
  end
end
