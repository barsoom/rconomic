require 'economic/proxies/entity_proxy'

module Economic
  class EntryProxy < EntityProxy
    def find_by_date_interval(from_date, to_date)
      response = session.request(entity_class.soap_action('FindByDateInterval')) do
        soap.body = {
          'fromDate' => from_date,
          'toDate'   => to_date
        }
      end

      build_serial_number_array(response)
    end

    # Undocumented tip: if you only care about the min_number, pass in the maximum
    # possible value as max_number so you don't have to call `get_last_used_serial_number`:
    #
    #   max_number = 2**31 - 1  # Maximum int32.
    #
    def find_by_serial_number_interval(min_number, max_number)
      response = session.request(entity_class.soap_action('FindBySerialNumberInterval')) do
        soap.body = {
          'minNumber' => min_number,
          'maxNumber' => max_number
        }
      end

      serial_numbers = build_serial_number_array(response)
      handles = serial_numbers.map { |number|
        { "SerialNumber" => number }
      }

      unless handles.empty?
        entity_data = session.request(entity_class.soap_action('GetDataArray')) do
          soap.body = {'entityHandles' => { "EntryHandle" => handles } }
        end

        entry_data = ensure_array(entity_data[:entry_data])

        # Build Entity objects and add them to the proxy
        entry_data.each do |data|
          entity = build(data)
          entity.persisted = true
        end
      end

      self
    end

    def get_last_used_serial_number
      response = session.request(entity_class.soap_action('GetLastUsedSerialNumber'))
      response.to_i
    end

    def find(serial_number)
      response = session.request(entity_class.soap_action('GetData')) do
        soap.body = {
          'entityHandle' => {
            'SerialNumber' => serial_number
           }
        }
      end

      build(response)
    end

    private

      # Some values may be e.g. any of
      #   [{:serial_number=>"1"}, {:serial_number=>"2"}]  # Many results.
      #   {:serial_number=>"1"}                           # One result.
      #   nil                                             # No results.
      # This method consistently turns them into an array.
    def ensure_array(value)
      [value].flatten.compact
    end

    def build_serial_number_array(response)
      entry_handles = ensure_array(response[:entry_handle])

      entry_handles.map do |entry_handle|
        entry_handle[:serial_number].to_i
      end
    end
  end
end
