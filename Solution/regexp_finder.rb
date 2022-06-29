system "cls"

IP_REGEX = %r{
	\b
	(?<!\d\.)
	(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.
	(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.
	(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.
	(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)
	\b
	(?!\.\d)
}x

acces_file = File.new("access.log", 'r:UTF-8')
ip_arr = Hash.new


File.readlines(acces_file).each do |line|
	ip = line.match(IP_REGEX)
	is_found = 0

	if ip_arr.key?(ip[0]) == false
		ip_arr[ip[0]] = 1
	else
		ip_arr[ip[0]] += 1	
	end
end

ip_arr = ip_arr.sort_by {|_key, value| value}.reverse
ind = 1

print "TOP-10 popular IP:\n\n"

ip_arr.first(10).each do |key, value|
	print "#{ind}) #{key}:\t#{value}\trequests\n"
	ind += 1
end

#---------------------------------------------------------------------------------------------------------

print "\n\nSuspicious requests:\n\n"

warn_rx1 = /^(.+)"(GET|POST)/
warn_rx2 = /^(.+)"(.+)(x\d\d)"/
warn_rx3 = /^(.+)(\d+)(.+)"-" "-"$/
warn_rx4 = /^(.+)(https|http){1}:\/\/[-a-zA-Z0-9+]+\.([-a-z]{2,3})(\/[-a-zA-Z0-9"-"]+){0,5}/
warn_rx5 = /^(.+)"(GET|POST)\s\/\w\s/

File.readlines(acces_file).each do |line|
	warning_count = 0

	if !line.match(warn_rx1)
		warning_count += 1
	end

	if line.match(warn_rx2)
		warning_count += 1
	end

	if line.match(warn_rx3)
		warning_count += 1
	end

	if !line.match(warn_rx4)
		warning_count += 1
	end

	if line.match(warn_rx5)
		warning_count += 1
		print line
	end

	if warning_count >= 2
		print line
	end
end