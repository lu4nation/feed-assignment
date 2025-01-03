require "nokogiri"
require "json"

class ExternalService
  ONE_MEGA_BYTE = 1_048_576.0
  BATCH_LIMIT = ONE_MEGA_BYTE * 5

  attr_accessor :batch_limit, :batch_num

  def initialize(batch_limit=BATCH_LIMIT)
    @batch_num = 0
    @batch_limit = batch_limit
  end

  def call(batch)
    @batch_num += 1
    pretty_print(batch)
  end

  private

  def pretty_print(batch)
    products = JSON.parse(batch)
    puts format("\e[1mReceived batch%4d\e[22m", @batch_num)
    puts format('Size: %10.2fMB', (batch.bytesize / ONE_MEGA_BYTE))
    puts format('Products: %8d', products.size)
    puts "\n"
  end
end

def build_product(item)
  parsed_id = item.at_xpath("g:id")
  id = parsed_id.text if parsed_id
  parsed_title = item.at_xpath('title')
  title = parsed_title.text if parsed_title
  parsed_description = item.at_xpath('description')
  description = parsed_description.text if parsed_description
  return { id: id, title: title, description: description }
end


def process_feed_from_file(file_name, service)
  items = []
  ready_to_send = []
  
  doc = File.open(file_name) { |f| Nokogiri::XML(f) }
  for i in doc.at_xpath("//channel").elements do 
    
    product = build_product(i)
    items << product
    
    size = JSON.generate(items).bytesize
    if size > service.batch_limit then
      puts "Sending new batch"
      batch = JSON.generate(ready_to_send)
      puts batch
      service.call(batch)
      last_sent_line = i.line
      puts "Last line sent: #{last_sent_line}"
      
      puts 'Reseting batch'
      ready_to_send = []
      items = [] 
      items << product
      puts "---------------------\n"
    end
    
    ready_to_send << product
  end
  
  items=nil
  puts "Sending last batch"
  batch = JSON.generate(ready_to_send)
  service.call(batch)
end
