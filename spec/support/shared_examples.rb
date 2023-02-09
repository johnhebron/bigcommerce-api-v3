# frozen_string_literal: true

###########################
# Resource Shared Examples
###########################

RSpec.shared_examples 'an instantiable Resource' do
  it 'is of the correct type' do
    expect(resource).to be_a(class_name)
  end

  it 'contains a Bigcommerce::V3::Client' do
    expect(resource.client).to be_a(Bigcommerce::V3::Client)
  end

  it 'has a RESOURCE_URL' do
    expect(class_name::RESOURCE_URL).to eq(resource_url)
  end
end
