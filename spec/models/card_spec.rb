require 'spec_helper'

describe Card do
  
  it { should validate_presence_of(:title)}
  it { should validate_presence_of(:description)}
  it { should validate_presence_of(:price)}
  it { should validate_presence_of(:inventory)}
  it { should have_many(:orders) }

end