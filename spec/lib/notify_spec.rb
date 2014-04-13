require 'spec_helper'

describe Notify do
  before do
    class Article < ActiveRecord::Base
      self.table_name = 'articles'

      include Notify
      tracked :on => {
        :create => :create_channel,
        :update => [
          :update_channel,
          { :update_name_channel => proc { |m| m.name_was && m.name_changed? }}
        ],
        :destroy => [:destroy_channel, :some_other_channel]
      }
    end
  end

  describe "#subscribe" do
    context "create" do
      let(:new_name) { "another_name" }
      before {
        Article.subscribe(:create_channel) do |model|
          model.name = new_name
          model.save
        end

        Article.create(name: "test")
      }

      it "should fire subscribers code" do
        expect(Article.first.name).to eq new_name
      end
    end

    context "update" do
      let(:array) { [] }
      before {
        Article.subscribe(:update_name_channel) do |model|
          array << 1
        end
      }

      it "should fire subscribers code" do
        expected = expect do
          article = Article.create(name: "test")
          article.name = "another"
          article.save
        end
        expected.to change{array.size}.from(0).to(1)
      end
    end

    context "destroy" do
      let(:num) { "some" }
      before {
        Article.subscribe(:destroy_channel) do |model|
          num << "thing"
        end

        Article.subscribe(:some_other_channel) do |model|
          num << "!"
        end
      }

      it "should fire subscribers code" do
        expected = expect do
          article = Article.create(name: "test")
          article.destroy
        end
        expected.to change{num}.from("some").to("something!")
      end
    end
  end
end
