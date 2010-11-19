require 'rest_client'
require 'yajl/json_gem'

class Groundcrew < Struct.new(:squad_id, :api_key)

  # create a new instance and run a block inside of it to
  # make multiple authenticated calls
  def self.api(squad_id, api_key, &blk)
    new(squad_id, api_key).instance_eval(&blk)
  end

  # def invite params;  post 'people/invite', params; end

  def exec loc, script, params = {}
    params.merge! :script => script, :loc => loc
    http :post, "/exec", params
  end

  def add_people folx
    post "/people/import.json", :json => folx.to_json
  end

  def add_person name, params = {}
    params.merge! :name => name
    add_people [params]
  end

  def stream_people params = {}
    since = nil
    params[:query] = "s#{squad_id}"
    loop do
      params[:since] = since if since
      http(:get, "stream.js", params).each_line do |line|
        next unless line =~ /^(item|at)\((.*)\);$/
        case $1
        when 'at'; since = $2
        else
          item_args = Yajl::Parser.parse("[#{$2}]")
          next unless item_args[1] =~ /^Person__|^p/
          vals = item_args.pop
          vals.merge! Hash[%w{city_id id name thumb_url lat lng tags latch comm req}.zip(item_args)]
          yield Hashwrapper.new vals
        end
      end
      sleep 10
    end
  end


 private # support methods
  def http method, url, params = {}
    params.merge! :api_key => api_key, :squad => squad_id
    params = {:params => params} if method == :get
    RestClient.send(method, "http://gcapi.com/#{url}", params)
  end

  %w{ get post put delete}.each{ |x| define_method(x){ |*args| perform x, *args; } }
  def perform *args; json_parse http(*args); end
  def json_parse text; Hashwrapper.new(Yajl::Parser.parse(text)); end

  class Hashwrapper < Struct.new(:hash)
    def method_missing(method_name, *args)
      case child = hash[method_name.to_s]
      when Hash;  Hashwrapper.new child
      when Array; child.map{ |x| Hash === x ? Hashwrapper.new(x) : x }
      else child
      end
    end
  end
end
