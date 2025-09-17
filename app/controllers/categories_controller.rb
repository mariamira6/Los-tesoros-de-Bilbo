class CategoriesController < ApplicationController
  before_action :authorize!

  def index
    @categories = Category.all.order(name: :asc)
  end

  def new
    @category = Category.new
  end

  def edit
    category
  end

  def create
    @category = Category.new(category_params)

    if @category.save
      redirect_to categories_path, notice: t(".created")
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if category.update(category_params)
      redirect_to categories_path, notice: t(".updated"), status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    category.destroy!

    redirect_to categories_path, notice: t(".destroyed"), status: :see_other
  end

  private
    def category
      @category = Category.find(params.expect(:id))
    end

    def category_params
      params.expect(category: [ :name ])
    end
end
