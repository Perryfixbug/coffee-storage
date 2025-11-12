class StaticPagesController < ApplicationController
  def home
    # Số liệu tổng quan
    @total_products = Product.count
    @total_agencies = Agency.count
    @total_users = User.count
    @total_import_orders = ImportOrder.where("created_at >= ?", 7.days.ago ).count
    @total_export_orders = ExportOrder.where("created_at >= ?", 7.days.ago).count
    @total_inventory_value = Product.sum("quantity * price_per_unit")

    # Sản phẩm sắp hết hàng (<= 10)
    @low_stock_products = Product.where("quantity <= ?", 10).limit(5)

    # Hoạt động gần đây
    @recent_imports = ImportOrder.order(created_at: :desc).limit(5)
    @recent_exports = ExportOrder.order(created_at: :desc).limit(5)
  end

  def stat
    # 🔢 Thống kê tổng quan
    @product_count = Product.count
    @import_this_month = ImportOrder.where("created_at >= ?", 30.days.ago).count
    @export_this_month = ExportOrder.where("created_at >= ?", 30.days.ago).count

    # Tổng giá trị tồn kho
    @inventory_value = Product.sum("quantity * price_per_unit")

    # 👥 Nhân sự & đại lý
    @agency_count = Agency.count
    @user_count = User.count

    # 📊 Biểu đồ nhập - xuất theo ngày (30 ngày gần nhất)
    @import_chart_data = ImportOrder
      .where(created_at: 30.days.ago..Time.current)
      .group("DATE(created_at)").count

    @export_chart_data = ExportOrder
      .where(created_at: 30.days.ago..Time.current)
      .group("DATE(created_at)").count

    # ⚠️ Sản phẩm sắp hết hàng
    @low_stock_products = Product.where("quantity < 10").order(:quantity)

    # 🏆 Sản phẩm tồn kho cao nhất
    @top_stock_products = Product.order(quantity: :desc).limit(5)

    # 💰 Đơn hàng giá trị cao
    # Tính dựa trên tổng giá trị từ ordered_products
    @top_import_orders = ImportOrder
      .includes(:ordered_products)
      .to_a
      .sort_by { |o| -o.total_price }
      .first(5)

    @top_export_orders = ExportOrder
      .includes(:ordered_products)
      .to_a
      .sort_by { |o| -o.total_price }
      .first(5)

    # 🏪 Top agency hoạt động tích cực
    @top_agency_imports = Agency
      .joins(:orders)
      .where(orders: { type: 'ImportOrder' })
      .group("agencies.id")
      .select("agencies.*, COUNT(orders.id) AS import_count")
      .order("import_count DESC")
      .limit(10)

    @top_agency_exports = Agency
      .joins(:orders)
      .where(orders: { type: 'ExportOrder' })
      .group("agencies.id")
      .select("agencies.*, COUNT(orders.id) AS export_count")
      .order("export_count DESC")
      .limit(10)
  end


  def about
    @page_title = "Giới thiệu"
  end

  def help
    @page_title = "Trợ giúp"
  end
end
