module Faraday
  class Branches < Faraday::Middleware

    def call(env)
      path = env[:url].path
      branch = Reviewed::Article.branch

      if path =~ /#{Reviewed::Article.resource_url}/ && branch
        query = env[:url].query || {}
        branch = Reviewed::Article.branch
        env[:url].query = Faraday::Utils.build_query(query.merge(branch: branch))
      end

      @app.call(env)
    end
  end
end

Faraday.register_middleware :request, branches: Faraday::Branches
