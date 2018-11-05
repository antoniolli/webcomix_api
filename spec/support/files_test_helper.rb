module FilesTestHelper
  extend self
  extend ActionDispatch::TestProcess

  def png_name; Rails.root.join('spec', 'support', 'assets', 'test-image.png') end
  def png; upload(png_name, 'image/png') end

  def jpg_name; Rails.root.join('spec', 'support', 'assets', 'test-image.jpg') end
  def jpg; upload(jpg_name, 'image/jpg') end

  private

  def upload(file_path, type)
    fixture_file_upload(file_path, type)
  end
end
