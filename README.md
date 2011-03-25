noah-agents-dummy2
------------------
This is an example template for adding additional callback support to [Noah](https://github.com/lusis/Noah) as a distributable gem.

**This gem is pointless without having Noah installed**

## Anatomy of a Noah callback plugin
-------------------------------------
In a nutshell, a class needs to do four things to be a valid Noah callback plugin:

* mixin `Noah::Agents::Base`
* define a URI-style prefix as a constant named `PREFIX`
* define a class-level method called `callback!`

If you name your gem `noah-agents-*`, the Noah watcher daemon will automatically add your gem to a list of candidates to `require`.

Mixing in `Noah::Agents::Base` to your class will automatically register your `PREFIX` as a valid scheme for callbacks.

## How registration happens
----------------------------
When you mixin `Noah::Agents::Base` the following occurs:

* `Noah::Watchers.register_agent` is called with your class name (`Noah::Agents::Dummy2` in this case)
* the `register_agent` method adds your class to a class variable called `@@agents`

When the watcher daemon starts up, it creates an instance of  `Noah::Agent`. Noah::Agent has a class variable called `@@agents` as well that is populated by calling `Noah::Watchers.agents`.

The instance of `Noah::Agent` brokers all requests to the actual callback endpoints. It automatically detects when new watchers are registered in Noah. Currently there does not exist a way to dynamically load **NEW** callback schemes. I'm working on that as well.

## Notes on the `callback!` method
-----------------------------------
The `callback!` method will be passed two paramters - an array of "matches" registered with your callback uri prefix and a message.

The current matches format is a bit of a kludge. The format for each item in the matches array is:

`pattern|endpoint`

Both the pattern and the endpoint are determined by the user when they create new Watches in Noah. An example array of matches passed in would look something like this:

	['//noah/applications/my_third_app|dummy2://dummy2-my-third-app',
	 '//noah/configurations|dummy2://some-other-dummy-endpoint',
	 '//noah/ephemerals/myorg/myserver|dummy2://foobarbaz']

The pattern is in there mainly for informational/debuggin purposes at this point.
The message is currently a JSON dump of the state of an object in Noah.

Remember that a watcher agent does two things: defines which uri scheme it provides support for and sends messages to endpoints using that uri scheme. You should gracefully handle things like lookup failures or destination timeouts.

Currently, agents are required to be EventMachine-friendly (read: **Don't block the reactor!**). Looking at the actual `callback!` method for this gem:

	def self.callback!(matches, message)
	  EM::Iterator.new(matches).each do |watch, iter|
	   p, ep = watch.split("|")
	   logger.info("Sending message to: #{ep} for pattern: #{p}")
	   logger.debug("message received: #{message}")
	   iter.next
	  end
	end

It uses EM::Iterator to iterate over the list of registerd endpoints were previously matched and sends `message` to each one. If you compare this to `Noah::Agents::Dummy` and `Noah::Agents::HTTP` included in the Noah codebase, you'll probably see a bit of duplication. This is one other area I'd like to abstract out. The goal is that the iteration and logging will actually be moved OUT of this and instead the `callback!` method itself will be iterated.

Additionally, there's no in-built support for reformatting messages. This is next on the plate as the whole point of making callbacks pluggable is that events can be custom formatted for the callback endpoint. For example, a `rundeck://` endpoint might want to have no interest in the type of action performed on an object (create, update, delete) but instead only cares for the current value of that object. There's no reason to send the extranous information over.
