require 'httparty'
require 'json'
require 'thread'

NUM_THREADS = 4
Thread.abort_on_exception = true

@mutex = Mutex.new
@output = []
@url = ARGV[0] || "http://localhost:9292/cpu_bound"
@queue = (1..[50,ARGV[1].to_i || 200].min).inject(Queue.new, :push)

def do_stuff(url)
  start = Time.now
  response = HTTParty.get url
  response_time = Time.now - start
  ret = [response.code, response_time, url]
  @mutex.synchronize do
    @output.push ret
  end
  ret
end

@threads = Array.new(NUM_THREADS) do
  Thread.new do
    until @queue.empty?
      # This will remove the first object from @queue
      @queue.shift
      do_stuff(@url)
    end
  end
end

@threads.each(&:join)

puts '<<<<<<<<<<<<<< cut below this line >>>>>>>>>>>>>>>>>>>'
puts JSON.generate({data: @output})
puts '<<<<<<<<<<<<<< ------------------- >>>>>>>>>>>>>>>>>>>'

trap "INT" do
  # Remove any queued jobs from the list
  @queue.clear

  # Wait until any currently running threads have finished their current work and returned to queue.pop
  while @queue.num_waiting < @threads.count
    pending_threads = @threads.count - @queue.num_waiting
    puts "Waiting for #{pending_threads} threads to finish"
    sleep 1
  end

  # Kill off each thread now that they're idle and exit
  @threads.each(&:exit)
  Process.exit(0)
end
