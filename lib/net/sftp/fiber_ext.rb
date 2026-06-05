module Net; module SFTP
  class Session
    # Wait until the SFTP subsystem is fully open. When the underlying Net::SSH
    # session uses a Fiber-aware event loop, this cooperates with the scheduler
    # through Session#loop.
    def await_open
      loop { opening? }
      self
    end

    # Same as connect, but waits until the SFTP subsystem is ready.
    def connect!(&block)
      connect(&block)
      await_open
    end

    private

      def wait_for(request, property=nil)
        request.await
        if request.response.eof?
          nil
        elsif !request.response.ok?
          raise StatusException.new(request.response)
        elsif property
          request.response[property.to_sym]
        else
          request.response
        end
      end
  end
end; end
