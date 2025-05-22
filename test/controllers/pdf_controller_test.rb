require "test_helper"

class PdfControllerTest < ActionDispatch::IntegrationTest
  test "should get generate_pdf" do
    get pdf_generate_pdf_url
    assert_response :success
  end
end
