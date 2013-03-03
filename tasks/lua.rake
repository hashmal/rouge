require 'open-uri'



def lua_builtins_source(lua_functions)
  yield   "# automatically generated by `rake builtins:lua`"
  yield   "module Rouge"
  yield   "  module Lexers"
  yield   "    class Lua"
  yield   "      def self.builtins"
  yield   "        @builtins ||= {}.tap do |b|"
  lua_functions.each do |n, fs|
    yield "          b[#{n.inspect}] = Set.new %w(#{fs.join(' ')})"
  end
  yield   "        end"
  yield   "      end"
  yield   "    end"
  yield   "  end"
  yield   "end"
end

def get_lua_functions(manual_url)
  open(manual_url) do |f|
    f.map do |line|
      line[%r(^<A HREF="manual.html#pdf-(.+)">\1</A>), 1]
    end.compact
  end
end

def get_function_module(name)
  if name =~ /\./
    m = name.split('.').first
    m = 'modules' if m == 'package'
    m
  elsif %w(require module).include?(name)
    'modules'
  else
    'basic'
  end
end

namespace :builtins do
  task :lua do
    version = "5.2"
    lua_manual_url = "http://www.lua.org/manual/#{version}/"
    puts "Downloading function index for Lua #{version}" 
    functions = get_lua_functions(lua_manual_url)
    puts "#{functions.length} functions found:"
    
    modules = {}
    functions.each do |full_function_name|
      m = get_function_module(full_function_name)
      (modules[m] ||= []) << full_function_name
      puts "  #{full_function_name}"
    end
        
    File.open('lib/rouge/lexers/lua/builtins.rb', 'w') do |f|
      lua_builtins_source(modules) do |line|
        f.puts line
      end
    end
  end
end
