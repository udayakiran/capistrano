oad File.expand_path("../tasks/svn.rake", __FILE__)

require 'capistrano/scm'

class Capistrano::Svn < Capistrano::SCM

  # execute svn in context with arguments
  def svn(*args)
    args.unshift(:svn)
    context.execute *args
  end

  module DefaultStrategy
    def test
      test! " [ -d #{repo_path}/.svn ] "
    end


    def check
      test! :svn, :info, repo_url,  "--no-auth-cache --username #{fetch(:scm_username)} --password #{fetch(:scm_password)}"
    end

    def clone
      svn :checkout, repo_url, repo_path, "--no-auth-cache --username #{fetch(:scm_username)} --password #{fetch(:scm_password)}"
    end

    def update
      svn :update, "--no-auth-cache --username #{fetch(:scm_username)} --password #{fetch(:scm_password)}"
    end

    def release
      svn :export, '.', release_path
    end
    
    def fetch_revision
      context.capture(:svn," log --no-auth-cache --username #{fetch(:scm_username)}", "--password \
#{fetch(:scm_password)}"," -r HEAD -q | tail -n 2 | head -n 1 | sed \"s/\ \|.*/''/\"")
    end
  end
end


