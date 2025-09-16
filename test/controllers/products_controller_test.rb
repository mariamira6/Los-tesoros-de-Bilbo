require "test_helper"

class ProductsControllerTest < ActionDispatch::IntegrationTest
  test "render a list of products" do
    get products_path

    assert_response :success
    assert_select ".product", 4
    assert_select ".category", 4
  end

  test "render a list of products filtered by category" do
    get products_path(category_id: categories(:books).id)

    assert_response :success
    assert_select ".product", 3
  end

  test "render a list of products filtered by price" do
    get products_path(min_price: 45, max_price: 60)

    assert_response :success
    assert_select ".product", 2
  end

  test "render a detailed product page" do
    get product_path(products(:lord_of_the_rings))

    assert_response :success
    assert_select ".title", "El Señor de los Anillos"
    assert_select ".description", "El mejor libro de la historia"
    assert_select ".price", "45€"
    assert_select ".category_name", "Categoría: #{categories(:books).name}"
  end

  test "render a new product form" do
    get new_product_path

    assert_response :success
    assert_select "form"
  end

  test "allow to create a new product" do
    post products_path, params: {
      product:
      {
        title: "El Señor de los Anillos",
        description: "La historia de Frodo y Sam",
        price: 45,
        category_id: categories(:books).id
      }
    }

    assert_redirected_to products_path
    assert_equal flash[:notice], "El producto se ha añadido correctamente."
  end

    test "does not allow to create a new product with empty fields" do
    post products_path, params: {
      product:
      {
        title: "",
        description: "La historia de Frodo y Sam",
        price: 45,
        category_id: categories(:books).id
      }
    }

    assert_response :unprocessable_entity
  end

    test "render a edit product form" do
    get edit_product_path(products(:the_hobbit))

    assert_response :success
    assert_select "form"
  end

   test "allow to update a product" do
    patch product_path(products(:the_hobbit)), params: {
      product:
      {
        price: 55
      }
    }

    assert_redirected_to products_path
    assert_equal flash[:notice], "El producto se ha actualizado correctamente."
  end

  test "does not allow to update a product" do
    patch product_path(products(:the_hobbit)), params: {
      product:
      {
        price: nil
      }
    }

    assert_response :unprocessable_entity
  end

  test "can delete products" do
    assert_difference("Product.count", -1) do
      delete product_path(products(:the_hobbit))
    end

    assert_redirected_to products_path
    assert_equal flash[:notice], "El producto se ha eliminado correctamente."
  end
end
