class OrderedProductsController < ApplicationController
  before_action :set_ordered_product, only: %i[ show edit update destroy ]

  # GET /ordered_products or /ordered_products.json
  def index
    @ordered_products = OrderedProduct.all
  end

  # GET /ordered_products/1 or /ordered_products/1.json
  def show
  end

  # GET /ordered_products/new
  def new
    @ordered_product = OrderedProduct.new
  end

  # GET /ordered_products/1/edit
  def edit
  end

  # POST /ordered_products or /ordered_products.json
  def create
    @ordered_product = OrderedProduct.new(ordered_product_params)

    respond_to do |format|
      if @ordered_product.save
        format.html { redirect_to @ordered_product, notice: "Ordered product was successfully created." }
        format.json { render :show, status: :created, location: @ordered_product }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @ordered_product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /ordered_products/1 or /ordered_products/1.json
  def update
    respond_to do |format|
      if @ordered_product.update(ordered_product_params)
        format.html { redirect_to @ordered_product, notice: "Ordered product was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @ordered_product }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @ordered_product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /ordered_products/1 or /ordered_products/1.json
  def destroy
    @ordered_product.destroy!

    respond_to do |format|
      format.html { redirect_to ordered_products_path, notice: "Ordered product was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_ordered_product
      @ordered_product = OrderedProduct.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def ordered_product_params
      params.expect(ordered_product: [ :quantity, :price_per_unit, :product_id, :order_id ])
    end
end
