require 'rubygems'
require 'ramaze'

class MainController < Ramaze::Controller
  def index
    "Hello world!  I'm Ramaze running from WebbyNode!  :)"
  end
end

Ramaze.start :adapter => :mongrel, :port => 8080
