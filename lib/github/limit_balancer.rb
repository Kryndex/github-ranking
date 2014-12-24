require 'octokit'
require 'singleton'

module Github
  class LimitBalancer
    include Singleton

    def client
      clients.max { |c| c.rate_limit.remaining }.dup
    end

    private

    def clients
      @clients ||= access_tokens.map { |t| Octokit::Client.new(access_token: t) }
    end

    def access_tokens
      @access_tokens ||= Rails.application.secrets[:github_access_tokens]
    end
  end
end