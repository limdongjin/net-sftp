require 'common'

class FiberExtTest < Net::SFTP::TestCase
  def test_await_open_runs_loop_while_opening_and_returns_self
    sftp = Net::SFTP::Session.allocate
    sftp.expects(:loop).yields
    sftp.expects(:opening?).returns(false)

    assert_equal sftp, sftp.await_open
  end

  def test_wait_for_awaits_request_and_returns_response
    sftp = Net::SFTP::Session.allocate
    response = stub(:eof? => false, :ok? => true)
    request = stub(:response => response)
    request.expects(:await).once

    assert_equal response, sftp.send(:wait_for, request)
  end

  def test_wait_for_returns_property_after_await
    sftp = Net::SFTP::Session.allocate
    response = stub(:eof? => false, :ok? => true)
    response.expects(:[]).with(:handle).returns("handle")
    request = stub(:response => response)
    request.expects(:await).once

    assert_equal "handle", sftp.send(:wait_for, request, :handle)
  end
end
