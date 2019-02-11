#!/usr/bin/ruby  -w
require 'open3'

module XdoTool
	BIN = 'xdotool'
	EXEC = ::ENV['PATH'].split(::File::PATH_SEPARATOR).map { |path| ::File.join(path, BIN) if ::File.executable?(::File.join(path, BIN)) }.compact.last
	raise RuntimeError, "No #{BIN} found in the exported paths. Please make sure you have #{BIN} installed" unless EXEC

	class << self
		def getdisplaygeometry() Open3.capture2("#{EXEC} getdisplaygeometry")[0].split.map(&:to_i) end

		def mousemove(pos = {})
			pos[:x] = rand(0..getdisplaygeometry[0]) unless pos[:x]
			pos[:y] = rand(0..getdisplaygeometry[1]) unless pos[:y]
			Open3.popen2e("#{EXEC} mousemove #{pos[:x].to_i} #{pos[:y].to_i}")
			pos
		end

		def getwinmousexy() Open3.capture2("#{EXEC} getmouselocation --shell")[0].split.map { |xy| xy.split('=') }.map { |xy| {xy[0].to_sym => xy[1].to_i} }.reduce(&:merge) end

		# Example: XdoTool.new.getmousexy # => [Integer, Integer]
		def getmousexy() Open3.capture2("#{EXEC} getmouselocation --shell")[0].split[0..1].map { |x| x[/\d+/].to_i } end

		# example: XdoTool.new.click(repeat: 5, delay: 500, button: 'middle')
		# repeat: n times. Default: 1
		# delay: n milliseconds. Default: 100 milliseconds. Only available with repeat
		# button: 'left', 'right', 'middle', 'wheel up'/'scroll up', 'wheel down'/'scroll down'. Default: 'left'
		def click(opts = {})
			repeat = opts[:repeat] ? opts[:repeat].to_i : 1
			delay = opts[:delay] ? opts[:delay].to_i : 100
			delay = 0 if repeat == 1

			case opts[:button].to_s.strip.downcase
				when 'middle' then button = 2
				when 'right' then button = 3

				when 'wheel up', 'scroll up' then button = 4
				when 'wheel down', 'scroll down' then button = 5

				else button = 1
			end
			Open3.capture2("#{EXEC} click --repeat #{repeat} --delay #{delay} #{button}")
		end

		def clickat(opt={})
			x, y = opt[:x], opt[:y]
			raise ArgumentError, 'No coordinate specified. Please mention x, and y.' unless x && y

			mousemove(x: x.to_i, y: y.to_i)
			sleep opt[:sleep].to_f
			click(repeat: opt[:repeat], delay: opt[:delay], button: opt[:button])
			opt
		end

		def mousedown(opts={})
			window = opts[:window] ? opts[:window] : getactivewindow
			case opts[:button].to_s.strip.downcase
				when 'middle' then button = 2
				when 'right' then button = 3

				when 'wheel up', 'scroll up' then button = 4
				when 'wheel down', 'scroll down' then button = 5

				else button = 1
			end

			Open3.capture2("#{EXEC} mousedown #{'--clearmodifiers' if opts[:clearmodifiers]} --window #{window} #{button}")
			{window: window, button: button}
		end

		# mouseup releases the mouse button.
		# example: XdoTool.mouseup(window: XdoTool.getactivewindow, button: 'left'/'middle'/'right'/'wheel up','wheel down'/'scroll up'/'scroll down')
		# Default options: window: XdoTool.getactivewindow, button: 'left'
		# mouseup(Hash) # => Hash
		def mouseup(opts={})
			window = opts[:window] ? opts[:window] : getactivewindow
			case opts[:button].to_s.strip.downcase
				when 'middle' then button = 2
				when 'right' then button = 3

				when 'wheel up', 'scroll up' then button = 4
				when 'wheel down', 'scroll down' then button = 5

				else button = 1
			end

			Open3.capture2("#{EXEC} mouseup #{'--clearmodifiers' if opts[:clearmodifiers]} --window #{window} #{button}")
			{window: window, button: button}
		end

		# key_names(String) # => String
		def key_names(key)
			case key.to_s.downcase
				when "\n" then key = 'KP_Enter' ; when '!' then key = 'exclam' ; when '.' then key = 'period' ; when ';' then key = 'semicolon'
				when ',' then key = 'comma' ; when '@' then key = 'at' ; when '$' then key = 'dollar' ; when '%' then key = 'percent'
				when '^' then key = 'asciicircum' ; when ' ' then key = 'space' ; when '"' then key = 'quotedbl' ; when "'" then key = 'quoteright'
				when '`' then key = 'quoteleft' ; when '/' then key = 'slash' ; when ':' then key = 'colon' ; when '<' then key = 'less'
				when '>' then key = 'greater' ; when '{' then key = 'braceleft' ; when '[' then key = 'bracketleft' ; when '(' then key = 'parenleft'
				when '}' then key = 'braceright' ; when ']' then key = 'bracketright' ; when ')' then key = 'parenright' ; when '?' then key = 'question'
				when '_' then key = 'underscore' ; when '*' then key = 'asterisk' ; when '\\' then key = 'backslash' ; when '&' then key = 'ampersand'
				when '#' then key = 'numbersign' ; when '+' then key = 'plus' ; when '-' then key = 'minus' ; when '―' then key = 'minus'
				when '’' then key = 'quoteright' ; when '=' then key = 'equal'
				when '|' then key = 'bar' ; when '~' then key = 'asciitilde'
			end
			key
		end

		def keypress(opts = {})
			repeat = opts[:repeat] ? opts[:repeat] : 1
			delay = opts[:delay] ? opts[:delay] : 100
			delay = 0 if repeat == 1

			r_key = opts[:key] ? opts[:key].to_s.chr : "\n"
			key = key_names(r_key)

			Open3.capture2("#{EXEC} key --repeat #{repeat} --delay #{delay} #{key}")
			r_key
		end

		def type(str) Open3.capture2("#{EXEC}", 'type', '--delay', '0', "#{str}") ; str end

		def keydown(opts)
			repeat = opts[:repeat] ? opts[:repeat] : 1
			delay = opts[:delay] ? opts[:delay] : 100
			delay = 0 if repeat == 1

			r_key = opts[:key] ? opts[:key] : "\n"
			key = key_names(r_key)

			Open3.capture2("#{EXEC} keydown --repeat #{repeat} --delay #{delay} #{'--clearmodifiers' if opts[:clearmodifiers]} #{key}")
			key
		end

		def keyup(opts={})
			repeat = opts[:repeat] ? opts[:repeat] : 1
			delay = opts[:delay] ? opts[:delay] : 100
			delay = 0 if repeat == 1

			r_key = opts[:key] ? opts[:key] : 'Return'
			key = key_names(r_key)

			Open3.capture2("#{EXEC} keyup --repeat #{repeat} --delay #{delay} #{'--clearmodifiers' if opts[:clearmodifiers]} #{key}")
			key
		end

		def getactivewindow() Open3.capture2e("#{EXEC} getactivewindow")[0].to_i end
		def windowminimize(window=getactivewindow) Open3.capture2e("#{EXEC} windowminimize #{window}") ; window end
		def windowkill(window=getactivewindow) Open3.capture2e("#{EXEC} windowkill #{window}") ; window end
		def windowclose(window=getactivewindow) Open3.capture2e("#{EXEC} windowclose #{window}") ; window end
		def windowraise(window=getactivewindow) Open3.capture2e("#{EXEC} windowraise #{window}") ; window end
		def selectwindow() Open3.capture2("#{EXEC} selectwindow")[0].to_i end

		def windowsize(opt={})
			window = opt[:window] ? opt[:window] : getactivewindow
			raise RuntimeError, "usage: XdoTool.windowsize(x: Integer, y: Integer, window: Integer, sync: Boolean, usehints: Boolean)" if opt[:x].nil? || opt[:y].nil?
			Open3.capture2("#{EXEC} windowsize #{'--sync' if opt[:sync]} #{'--usehints' if opt[:usehints]} #{window} #{opt[:x]} #{opt[:y]}")
			window
		end

		def windowmove(opt={})
			window = opt[:window] ? opt[:window] : getactivewindow
			raise RuntimeError, "usage: XdoTool.windowsize(x: Integer, y: Integer, window: Integer, sync: Boolean, usehints: Boolean)" if opt[:x].nil? || opt[:y].nil?
			Open3.popen2("#{EXEC} windowmove #{window} #{opt[:x]} #{opt[:y]}")
			window
		end

		def windowmap(window=getactivewindow) Open3.capture2e("#{EXEC} windowmap #{window}") ; window end
		def windowunmap(window=getactivewindow) Open3.capture2e("#{EXEC} windowunmap #{window}") ; window end

		alias hidewindow windowunmap
		alias unhidewindow windowmap
		alias currentwindow getactivewindow
		alias setmousexy mousemove
		alias press keypress
		alias resizewindow windowsize
		alias setwindowxy windowmove
	end
end
