### Proc Object ###
my_proc = Proc.new {puts "tweet"}
my_proc.call # => tweet

# the same 
my_proc = Proc.new do
  puts "tweet"
end
my_proc.call # => tweet

### Lambda ###
my_proc = lambda {puts "tweet"}
my_proc.call # => tweet

# the same (from ruby 1.9)
my_proc = -> {puts "tweet"}
my_proc.call # => 

### block vs. lambda ###
# block + yield
class Tweet
	def post
		if authenticated?(@user, @password)
			yield
		elsif 
			raise 'Auth Error'
		end
	end
end

tweet = Tweet.new('Ruby Bits!')
tweet.post { puts "Sent!" }

# lambda
class Tweet
	def post(success, error)
		if authenticated?(@user, @password)
			success.call
		elsif
			error.call
		end
	end
end

tweet = Tweet.new('Ruby Bits!')
success = -> { puts "Sent!" }
error = -> { raise 'Auth Error' }
tweet.post(success, error)

## & 1.lambda to block
# block
tweets = ["First tweet", "Second tweet"]
tweet.each do |tweet|
	puts tweet
end

# &block - changes labda (proc) to block
tweets = ["First tweet", "Second tweet"]
printer = lambda { |tweet| puts tweet }
tweets.each(&printer) # & proc to block

## & 2.block to proc
# defining a method with & in front of a parameter
# turns a block into a proc
# so it can be assigned to a parameter
def each(&block)
end

class Timline
	attr_accessor :tweets

	def each
		tweets.each { |tweet| yield tweet }
	end
end

timeline = Timline.new(tweets)
timeline.each do |tweet|
	puts tweet
end

# the same using &block
class Timeline
	attr_accessor :tweets

	def each(&block) #block into proc
		tweets.each(&block) # proc back into a block
	end
end

# optional block
class Timeline
	attr_accessor :tweets

	def print
		if block_given?
			tweets.each { |tweet| puts yield tweet }
		else
			puts tweets.join(", ")
		end
	end
end

timeline = Timeline.new
timeline.tweets = ["One, Two"]

# print without block
timeline.print # => One, Two

# print with block
timeline.print { |tweet| 
	"tweet: #{tweet}"
}

### Closure ###
# current state of local variables is
# preserved when a lambda is created

def tweet_as(user)
	lambda { |tweet| puts "#{user}: #{tweet}"}
end

#creating a lambda
greeg_tweet = tweet_as("greegpollack")
# => resolves as: lambda { |tweet| puts "greegpollack: #{tweet}" }

greeg_tweet.call("Awesome!") # => gregpollack: Awesome!

