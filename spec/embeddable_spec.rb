require 'spec_helper.rb'

describe Reviewed::Embeddable do

  after(:each) do
    Reviewed::MockEmbeddable._embedded_many = nil
    Reviewed::MockEmbeddable._embedded_one = nil
  end

  module Reviewed
    class MockEmbeddable
      include Reviewed::Embeddable
    end
  end

  describe 'accessors' do

    it '_embedded_many' do
      Reviewed::MockEmbeddable._embedded_many = "test"
      Reviewed::MockEmbeddable._embedded_many.should eql("test")
    end

    it '_embedded_one' do
      Reviewed::MockEmbeddable._embedded_one = "test"
      Reviewed::MockEmbeddable._embedded_one.should eql("test")
    end
  end

  describe '#has_many' do

    context 'no options' do

      context 'valid name' do

        it 'stores the correct embedded relationship' do
          Reviewed::MockEmbeddable._embedded_many.should be_empty
          Reviewed::MockEmbeddable.has_many("mock_embeddables")
          Reviewed::MockEmbeddable._embedded_many.should eql([{ "mock_embeddables" => Reviewed::MockEmbeddable }])
        end
      end

      context 'invalid name' do

        it 'errors' do
          expect {
            Reviewed::MockEmbeddable.has_many("bad_name")
          }.to raise_error
        end
      end
    end

    context ":as" do

      it 'stores the correct embedded relationship' do
        Reviewed::MockEmbeddable._embedded_many.should be_empty
        Reviewed::MockEmbeddable.has_many("mock_embeddables", as: "test")
        Reviewed::MockEmbeddable._embedded_many.should eql([{ "test" => Reviewed::MockEmbeddable }])
      end
    end

    context "class_name" do

      it 'stores the correct embedded relationship' do
        Reviewed::MockEmbeddable._embedded_many.should be_empty
        Reviewed::MockEmbeddable.has_many("mock_embeddables", class_name: "Reviewed::Article")
        Reviewed::MockEmbeddable._embedded_many.should eql([{ "mock_embeddables" => Reviewed::Article }])
      end
    end
  end

  describe '#has_one' do

    it 'stores the correct embedded relationship' do
      Reviewed::MockEmbeddable._embedded_one.should be_empty
      Reviewed::MockEmbeddable.has_one("mock_embeddable")
      Reviewed::MockEmbeddable._embedded_one.should eql([{ "mock_embeddable" => Reviewed::MockEmbeddable }])
    end
  end

  describe 'objectify' do

    let(:mocked) { Reviewed::MockEmbeddable.new }
    let(:data) { { articles: [1,2,3] } }

    it 'calls objectify_has_many' do
      mocked.should_receive(:objectify_has_many)
      mocked.objectify({})
    end

    it 'calls objectify_has_one' do
      mocked.should_receive(:objectify_has_one)
      mocked.objectify({})
    end
  end

  describe 'objectify_has_many' do

    let(:data) { { "articles" => [{},{}] } }
    let(:mocked) { Reviewed::MockEmbeddable.new }

    it 'objectifies' do
      Reviewed::MockEmbeddable._embedded_many = [ { "articles" => Reviewed::Article } ]
      mocked.objectify_has_many(data)["articles"].each do |obj|
        obj.should be_an_instance_of Reviewed::Article
      end
    end
  end

  describe 'objectify_has_one' do

    let(:data) { { "articles" => {} } }
    let(:mocked) { Reviewed::MockEmbeddable.new }

    it 'objectifies' do
      Reviewed::MockEmbeddable._embedded_one = [ { "articles" => Reviewed::Article } ]
      mocked.objectify_has_one(data)["articles"].should be_an_instance_of(Reviewed::Article)
    end
  end

  describe '.embedded_name' do

    context 'plural' do

      it 'returns a class name' do
        Reviewed::Embeddable.embedded_name("mock_embeddables").should eql("Reviewed::MockEmbeddable")
      end
    end

    context 'singular' do

      it 'returns a class name' do
        Reviewed::Embeddable.embedded_name("mock_embeddable").should eql("Reviewed::MockEmbeddable")
      end
    end
  end

  describe '.embedded_class' do

    context 'opts_name' do

      context 'valid' do

        it 'returns a class_constant' do
          Reviewed::Embeddable.embedded_class("test", "Reviewed::MockEmbeddable")
            .should eql(Reviewed::MockEmbeddable)
        end
      end

      context 'invalid' do

        it 'errors' do
          expect {
            Reviewed::Embeddable.embedded_class("test", "Reviewed::MockBad")
          }.to raise_error
        end
      end
    end

    context 'name' do

      context 'valid' do

        it 'returns a class_constant' do
          Reviewed::Embeddable.embedded_class("mock_embeddables")
            .should eql(Reviewed::MockEmbeddable)
        end
      end
    end
  end
end
