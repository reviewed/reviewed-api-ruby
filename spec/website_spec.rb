require 'spec_helper'

describe Reviewed::Website do

  describe 'all' do
    use_vcr_cassette 'website/where_collection'

    it 'calls "where" with correct arguements' do
      Reviewed::Website.should_receive(:where).with({per_page: 'all'})
      Reviewed::Website.all
    end
  end
end
