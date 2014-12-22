require "language_pack"
require "language_pack/rails3"

# Rails 4 Language Pack. This is for all Rails 4.x apps.
class LanguagePack::Rails4 < LanguagePack::Rails3
  # detects if this is a Rails 4.x app
  # @return [Boolean] true if it's a Rails 4.x app
  def self.use?
    instrument "rails4.use" do
      rails_version = bundler.gem_version('railties')
      return false unless rails_version
      is_rails4 = rails_version >= Gem::Version.new('4.0.0.beta') &&
                  rails_version <  Gem::Version.new('4.1.0.beta1')
      return is_rails4
    end
  end

  def name
    "Ruby/Rails"
  end

  def default_process_types
    instrument "rails4.default_process_types" do
      super.merge({
        "web"     => "bin/rails server -p $PORT -e $RAILS_ENV",
        "console" => "bin/rails console"
      })
    end
  end

  def build_bundler
    instrument "rails4.build_bundler" do
      super
    end
  end

  def compile
    instrument "rails4.compile" do
      super
    end
  end

  private

  def install_plugins
    instrument "rails4.install_plugins" do
      return false if bundler.has_gem?('rails_12factor')
      plugins = ["rails_stdout_logging"].reject { |plugin| bundler.has_gem?(plugin) }
      return false if plugins.empty?

    warn <<-WARNING
Include 'rails_12factor' gem to enable all platform features
See https://devcenter.heroku.com/articles/rails-integration-gems for more information.
WARNING
    # do not install plugins, do not call super
    end
  end
end
