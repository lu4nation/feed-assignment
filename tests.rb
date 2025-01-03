require "./logic"

TEST_INPUT_FILE_NAME = "part.xml"
MINI_INPUT_FILE_NAME = "mini.xml"
TEST_BATCH_LIMIT = 1000
LOWER_BATCH_LIMIT = 600

RSpec.describe "Testing process_feed_from_file()", "#send_batches" do
  context "with 2 products and limit greater" do
    it "should send 1 batch" do
        service = service = ExternalService.new(TEST_BATCH_LIMIT)
        process_feed_from_file(TEST_INPUT_FILE_NAME, service)

        expect(service.batch_num).to eq 1
    end
  end

  context "with 2 products and limit lower" do
    it "should send 2 batches" do
        service = service = ExternalService.new(LOWER_BATCH_LIMIT)
        process_feed_from_file(TEST_INPUT_FILE_NAME, service)

        expect(service.batch_num).to eq 2
    end
  end
end

doc_part = File.open(MINI_INPUT_FILE_NAME) { |f| Nokogiri::XML(f) }
first_item = doc_part.at_xpath("//channel").elements.first
missing_fields_item = doc_part.at_xpath("//channel").elements.at(1)

RSpec.describe "Testing build_product" do
  context "with fields filled" do
    it "should return complete hash" do
      result = build_product(first_item)
      expect(result).to eq({id: "123", title: "title", description: "mini"})
    end
  end
  context "with fields missing" do
    it "should return hash with nil" do
      result = build_product(missing_fields_item)
      expect(result).to eq({id: "1234", title: "title2", description: nil})
    end
  end
end
