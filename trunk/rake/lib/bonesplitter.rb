require 'stringio'



module BoneSplitter
	@libs = {}

	class <<BoneSplitter
		attr_accessor :libs
	end
	
	def dependencies(*libs, &msg)
		lib=nil
		libs.each { |lib|
			require lib
		}
	rescue LoadError => e
		abort(block_given? ? yield(lib) : e.message)
	end
	alias dependency dependencies
	
	def optional_task(name, depends_on_constant)
		# puts "#{name} requires #{depends_on_constant}: #{!!deep_const(depends_on_constant)}"
		if deep_const(depends_on_constant) then
			yield
		else
			task name do
				"You're missing a dependency to run this thread (#{depends_on_constant})"
			end
		end
	end
	
	def deep_const(name)
		name.split(/::/).inject(Object) { |nesting, name|
			return nil unless nesting.const_defined?(name)
			nesting.const_get(name)
		}
	end

	def version_proc(constant)
		proc {
			file    = constant.gsub(/::/, '/').downcase
			require(file)
			version = deep_const(constant)
			version && version.to_s
		}
	end
	
	def detect_libs(libs)
		libs.each { |lib|
			begin
				silenced do
					require lib
				end
				BoneSplitter.libs[lib.gsub(/\//, '_').to_sym] = true
			rescue LoadError
				puts "Not found: #{lib}"
			end
		}
	end
	
	def quietly
		verbose, $VERBOSE = $VERBOSE, nil
		yield
	ensure
		$VERBOSE = verbose
	end
	
	def silenced
		a,b     = $stderr, $stdout
		$stderr = StringIO.new
		$stdout = StringIO.new
		yield
	ensure
		$stderr, $stdout = a,b
	end
	
	def lib?(name)
		BoneSplitter.libs[name.to_sym]
	end
end
