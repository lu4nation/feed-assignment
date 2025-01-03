require "./logic"

INPUT_FILE_NAME = "feed.xml"

def main
  # Dependency 
  service = ExternalService.new(ExternalService::BATCH_LIMIT)
  process_feed_from_file(INPUT_FILE_NAME, service)
end

main()
