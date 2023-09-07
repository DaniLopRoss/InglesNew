require "test_helper"

class FileUploadsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @file_upload = file_uploads(:one)
  end

  test "should get index" do
    get file_uploads_url
    assert_response :success
  end

  test "should get new" do
    get new_file_upload_url
    assert_response :success
  end

  test "should create file_upload" do
    assert_difference("FileUpload.count") do
      post file_uploads_url, params: { file_upload: { name: @file_upload.name } }
    end

    assert_redirected_to file_upload_url(FileUpload.last)
  end

  test "should show file_upload" do
    get file_upload_url(@file_upload)
    assert_response :success
  end

  test "should get edit" do
    get edit_file_upload_url(@file_upload)
    assert_response :success
  end

  test "should update file_upload" do
    patch file_upload_url(@file_upload), params: { file_upload: { name: @file_upload.name } }
    assert_redirected_to file_upload_url(@file_upload)
  end

  test "should destroy file_upload" do
    assert_difference("FileUpload.count", -1) do
      delete file_upload_url(@file_upload)
    end

    assert_redirected_to file_uploads_url
  end
end
