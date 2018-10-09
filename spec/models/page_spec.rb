require 'rails_helper'

RSpec.describe Page, type: :model do
   # Association test
  it { should belong_to(:comic) }

  # Validation tests
  # ensure columns title and created_by are present before saving
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:number) }
  it { should validate_presence_of(:is_public) }

  # describe 'Attachment' do
  #   it 'is valid  ' do
  #     subject.image.attach(io: File.open(fixture_path + '/dummy_image.jpg'), filename: 'attachment.jpg', content_type: 'image/jpg')
  #     expect(subject.image).to be_attached
  #   end
  # end
end
