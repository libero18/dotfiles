#! /usr/bin/env ruby
require 'ipaddr'

module ConvertToCIDR
  def inet_ntoa(integer)
    IPAddr.new(integer, Socket::AF_INET).to_s
  end

  def inet_aton(ip)
    return ip.to_i if /^\d+$/ =~ ip
    raise ArgumentError, "invalid IP: #{ip}" unless /^(\d+\.){3}\d+$/ =~ ip

    IPAddr.new(ip).to_i
  end

  def ranges_for_v4(first, last, &b)
    raise LocalJumpError, "no block given" unless block_given?

    # convert IP to Integer
    first = inet_aton(first) unless first.kind_of?(Integer)
    last  = inet_aton(last)  unless last.kind_of?(Integer)

    # flip first,last if first > last
    first, last = last, first if first > last

    # do the magic
    # log10(x)/log10(2) == log2(x)
    log = (Math.log(last - first + 1)/Math.log(2)).to_i
    mask = 2 ** 32 - 2 ** log

    if first&mask == last&mask
      b.call(inet_ntoa(first), 32 - log)
    else
      ranges_for_v4(first, (last&mask) - 1, &b)
      ranges_for_v4(last&mask, last, &b)
    end
  end
  # make it both includable and directly callable
  class <<self; include ConvertToCIDR; end
end

def range_to_cidr(range_address='')
  # range_to_cidr("192.168.74.82")
  return range_address + "/32" if range_address =~ /^(\d+\.){3}\d+$/
  # range_to_cidr("192.168.93.6/25")
  return range_address if range_address =~ /^(\d+\.){3}\d+\/\d+$/

  # range_to_cidr("192.168.11.1-192.168.33.1")
  # range_to_cidr("192.168.51.9 192.168.63.21")
  # range_to_cidr("192.168.76.38 - 192.168.83.14")
  cidrs = []
  unless range_address.to_s.empty?
    range = range_address.split(/\s*-\s*|\s+/)
    if IPAddr.new(range[0]).ipv4? && IPAddr.new(range[1]).ipv4?
      ConvertToCIDR.ranges_for_v4(range[0], range[1]) do |address, mask|
        cidrs.push( [address, mask].join('/') )
      end
    elsif IPAddr.new(range[0]).ipv6? && IPAddr.new(range[1]).ipv6?
      # IPv6 未対応
      raise ArgumentError, "Unsupported IPv6"
    else
      raise ArgumentError, "Incorrect Arguments"
    end
  else
    raise ArgumentError, "No Arguments"
  end
  return cidrs
end

p range_to_cidr(ARGV[0])

