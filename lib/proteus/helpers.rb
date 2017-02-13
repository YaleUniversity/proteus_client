module Proteus
  # Helpers module to collect useful utility methods for
  # dealing with the input to and output from the Proteus API
  module Helpers
    # decompose takes a property string of the form: "foo=bar|baz=biz|boz=buz"
    # and decomposes it into a ruby hash { foo: 'bar', baz: 'biz', boz: 'buz' }
    def decompose(prop_string)
      return nil if prop_string.nil?
      props = {}
      prop_string.split('|').each do |i|
        k,v = i.split('=', 2)
        props[k.to_sym] = v
      end
      props
    end

    # compose takes a a ruby hash { foo: 'bar', baz: 'biz', boz: 'buz' } and
    # composes it into a property string of the form: "foo=bar|baz=biz|boz=buz"
    def compose(prop_hash)
      return nil if prop_hash.nil?
      prop_hash.map do |k, v|
        "#{k}=#{v}"
      end.join('|')
    end

    # normalize cleans up the response from the api --
    # when there is 1 item, the response is a hash: { item: { foo: 'bar', baz: 'biz' } },
    # but when there is >1 item, the response is a list:
    # { item: [ { foo: 'bar', baz: 'biz' }, { foo: 'boz', baz: 'buz' } ]
    def normalize(hash)
      hash ||= {}
      [hash[:item]].flatten
    end
  end
end
