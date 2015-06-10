# WRONG WAY!
if ! tweets.empty?
	puts "Timline:"
	puts tweets
end

# GOOD WAY!
# Instead of if ! use unless
unless tweets.empty?
	puts "Timline:"
	puts tweets
end

# WRONG WAY!
if attachment.file_path != nill
	attachement.post
end

# GOOD WAY!
#nil id=s treated ad false
if attachment.file_path != nill
	attachement.post
end

# true
"" - is treated as true
0 - is treated as true
[] - is treated as true

#INLINE CONDITION
if password.length < 8
	fail "Password to short"
end

fail "Password to short" if password.length < 8

# CONDITION RETURN VALUE
# if always returns value

if list_name
	options[:path] = "/#{user_name}/#{list_name}"
else
	options[:path] = "/#{user_name}"
end

options[:path] = if list_name
	"/#{user_name}/#{list_name}"
else
	"/#{user_name}"
end

# HASH ARGUMENTS
def tweet(message, options = {})
	status = Status.new
	status.lat = options[:lat]
	status.long = options[:long]
	status.body = message
	status.reply_id = options[:reply_id]
	status.post
end

# call method shows the meaing of the options
tweet("Practicint Ruby-Fu!",
	:lat => 28.55,
	:long => -81.09,
	:reply_id => 123123123
	)

# EXCEPTIONS (if ! to samo co unless)
def get_tweets(list)
	unless list.authorised?(@user)
		raise AuthorizationException.new
	end
	list.tweets
end

begin
	tweets = get_tweets(my_list)
rescue AuthorizationException
	warn "You are not authorozed to access this list"
end
end

# SPLAT ARGUMENTS
def mentions(status, *names)
	tweet("#{names.join(' ')} #{status}")
end

# status -> 'Your course rocks!', names[0] -> 'John', names[1] -> 'Thomas', names[2] ->'Json'
mention('Your course rocks!', 'John', 'Thomas', 'Json')

#  CLASS #

class Name
	def initialize(first, last = nil)
		@first = first
		@last = last
	end

	def format
		[@last, @first].compact.join(', ')
	end
end

user_names = []
user_names << Name.new('Bartosz', 'Kita')
user_names << Name.new('Bartoszek', 'Kowal')
user_names << Name.new('Kita')

user_names.each {|name| name.format}

### ACTIVESUPPORT ###

gem install ACTIVESUPPORT
gem install i18n

require 'active_support/all'

- ARRAY -
array = [1,2,3,4,5,6,7,8]
array.from[4] -> returns new array starrintg from posiotion 4
arry.to(2) -> return new array from the beginning to the position we pass as an argument
array.in_groups_of(3) -> splits the array into [[1,2,3], [4,5,6], [7,8,nil]]
array.split(2) -> split the arrays at the index that was passed !!!! removes the element that was split on !!!! -> [[1,3],[4,5,6,7,8]]

 - DATE - 
apocalipse = DateTime.new(2012, 12, 12, 14, 27, 45) -> Fri, 21 Dec 2012 14:27:45
apocalipse.at_beginning_of_day -> Fri, 21 Dec 2012 00:00:00
apocalipse.at_end_of_month -> Mon, 31 Dec 2012 23:59:59
apocalipse.at_beginning_of_year ->  Sun, 01 Jan 00:00:00

apocalipse.advance(years: 4, months: 2, weeks: 2, days: 12)
apocalipse.tomorrow
apocalipse.yesterday

- HASH -
options = {user: 'codeschool', lang: 'fr'}
new_options = {user: 'codeschool', lang: 'fr', password: 'dunno'}

options.diff(new_options) -> {password: 'dunno'}

options.stringnify_keys -> {"user" => "codeschool", "lang" => "fr"}

options = {user: 'codeschool', lang: 'fr'}
default = {lang: 'en', country: 'us'}

options.reverse_merge(default) => {user: 'codeschool', lang: 'fr', country: 'us'}

new_options.except(:password) -> removes :password -> {user: 'codeschool', lang: 'fr'}
new_options.assert_valid_keys(:user, :lang) -> throws an exception if the hash contains any keys beside those listed here
											-> Unknown key(s): passwoed (ArgumentError)

### PROC / LAMBDA / BLOCK  ###
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

### MODULES ###
# MIXIN - including module into the class

# Use extend to expose
# methods as a class method
# extend = static -> Class.method
class Tweet
	extend Searchable
end

module Searchable
	def find_all
	end
end
Tweet.find_all

# Use include to expose
# methods as instance method
# include = object.method
class Image
	include ImageUtils
end

module ImageUtils
	def preview
	end
end
image = user.imageimage.preview

# MIXIN - for object
class Image
end

module ImageUtils
	def preview
	end
end

image1 = Image.new
image.extend(ImageUtils) # Only this object can use methods from ImageUtils
image.preview

image2 = Image.new
image.preview
NoMethodError: undefined method 'prevew' for image2




