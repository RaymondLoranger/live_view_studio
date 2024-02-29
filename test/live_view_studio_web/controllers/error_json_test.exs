defmodule LiveView.StudioWeb.ErrorJSONTest do
  use LiveView.StudioWeb.ConnCase, async: true

  test "renders 404" do
    assert LiveView.StudioWeb.ErrorJSON.render("404.json", %{}) == %{
             errors: %{detail: "Not Found"}
           }
  end

  test "renders 500" do
    assert LiveView.StudioWeb.ErrorJSON.render("500.json", %{}) ==
             %{errors: %{detail: "Internal Server Error"}}
  end
end
