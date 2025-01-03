require "./logic"

TEST_INPUT_FILE_NAME = "part.xml"
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
