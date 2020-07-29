module Lograge
  module Formatters
    class Stackdriver
      def call(data)
        severity = case
                   when data[:status] < 400
                    'INFO'
                   when data[:status] < 500
                    'WARNING'
                   else
                    'ERROR'
                   end

        entry = {
          severity: severity,
          progname: 'lograge',
          requestMethod: data[:method],
          requestUrl: data[:fullpath],
          requestSize: data[:content_length],
          status: data[:status],
          userAgent: data[:user_agent],
          remoteIp: data[:remote_ip],
          serverIp: Socket.ip_address_list.detect(&:ipv4_private?).try(:ip_address),
          referer: data[:referer],
          latency: data[:duration],
          controller: data[:controller],
          action: data[:action],
          message: "[#{data[:status]}] #{data[:method]} #{data[:fullpath]} (#{[data[:controller], data[:action]].join('#')})"
        }
        "#{entry.to_json}\n"
      end
    end
  end
end
