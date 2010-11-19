require 'helper'

SQUAD = '4dpsb03a'           # replace with yours
KEY   = 'foobar_api_key'     # replace with yours

YOUR_NAME  = 'Some guy'      # replace with yours
YOUR_PHONE = '+19995551212'  # replace with yours


class TestGroundcrew < MiniTest::Unit::TestCase
  def test_exec
    Groundcrew.api(SQUAD, KEY) do
      exec 'San Francisco, CA',
        "nab 1 agent within 5mi\n"+
        "tell agent: this is your test message"
    end
  end

  def test_import
    Groundcrew.api(SQUAD, KEY) do
      add_person YOUR_NAME, :phone => YOUR_PHONE, :loc => 'San Francisco, CA'
    end
  end

  def test_stream
    Groundcrew.api(SQUAD, KEY) do
      stream_people do |person|
        puts "Someone: #{person.name} at #{person.lat}, #{person.lng}"
      end
    end
  end
end
