class SearchsController < ApplicationController
  def universalSearch
    query = params[:q].to_s.strip
    return render json: [] if query.blank?

    products = Product.where("LOWER(name) LIKE ?", "%#{query.downcase}%")
                      .limit(10)
                      .select(:id, :name)
                      .map { |p| p.attributes.merge(type: "product") }

    agencies = Agency.where("LOWER(name) LIKE ?", "%#{query.downcase}%")
                    .limit(10)
                    .select(:id, :name)
                    .map { |a| a.attributes.merge(type: "agency") }

    render json: (products + agencies)
  end

  def productSearch
    query = params[:q].to_s.strip
    return render json: [] if query.blank?

    # Tìm kiếm mờ theo id hoặc tên (ko phân biệt hoa thường)
    results =
      if query.match?(/^\d+$/)
        Product.where(id: query)
      else
        Product.where("LOWER(name) LIKE ?", "%#{query.downcase}%")
      end

    render json: results.limit(10)
  end

  def agencySearch
    query = params[:q].to_s.strip
    return render json: [] if query.blank?

    # Tìm kiếm mờ theo id hoặc tên (ko phân biệt hoa thường)
    results =
      if query.match?(/^\d+$/)
        Agency.where(id: query)
      else
        Agency.where("LOWER(name) LIKE ?", "%#{query.downcase}%")
      end

    render json: results.limit(10).select(:id, :name)
  end
end
