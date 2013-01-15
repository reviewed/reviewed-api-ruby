require 'spec_helper'

describe Reviewed::Website do

  describe 'all', vcr: true do

    it 'calls "where" with correct arguements' do
      Reviewed::Website.should_receive(:where).with({per_page: 'all'})
      Reviewed::Website.all
    end
  end
end
