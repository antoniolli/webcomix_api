require 'rails_helper'

RSpec.describe Comic, type: :model do
  # Association test
  it { should belong_to(:user) }

  # ensure Todo model has a 1:m relationship with the Item model
  it { should have_many(:pages).dependent(:destroy) }

  # Validation tests
  # ensure columns title and created_by are present before saving
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:description) }
  it { should validate_presence_of(:is_public) }
  it { should validate_presence_of(:is_comments_active) }

  # describe 'Attachment' do
  #   it 'is valid  ' do
  #     subject.image.attach(io: File.open(fixture_path + '/dummy_image.jpg'), filename: 'attachment.jpg', content_type: 'image/jpg')
  #     expect(subject.image).to be_attached
  #   end
  # end
end
