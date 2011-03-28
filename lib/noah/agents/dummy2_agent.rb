require 'noah/agents/base_agent'

module Noah::Agents
  class Dummy2Agent < Base

    PREFIX = "dummy2://"
    NAME = self.name
    DEFAULT_CONCURRENCY = 100

    def work!(matches, message)
      logger.info("Sending message to (#{ep})")
      logger.debug("Dummy2 message received: #{message}")
    end

  end
end
