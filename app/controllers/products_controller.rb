class ProductsController < ApplicationController
  rescue_from NoMethodError, with: :incorrect_url_message

  def index
    @products = Product.order(updated_at: :desc)
    @product = Product.new
  end

  def show
    product
  end

  def create
    @product = Product.add_or_update(product_params[:url])
    flash[:notice] = "Added successfully"
    redirect_to :products
  end

  private
  def product_params
    params.require(:product).permit(:url)
  end

  def product
    @product ||= Product.find(params[:id])
  end

  def incorrect_url_message
    flash[:error] = "Incorrect url"
    redirect_to :products
  end
end