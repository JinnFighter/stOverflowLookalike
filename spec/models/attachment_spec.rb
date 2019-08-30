require 'rails_helper'

RSpec.describe Attachment, type: :model do
  it { should belong_to :attachable }
  it { should validate_presence_of :file }

  it 'validates presence of file' do
    expect(Attachment.new(file: nil)).to_not be_valid
  end
end
