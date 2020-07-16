# TODO
# - able to be extended
# - able to be used without extending (module_function)
# - variant that returns nil instead of self
module ChainMail
  module Chainable
    module_function

    def chainable(*methods)
      methods.each do |method|
        original = instance_method(method)
        define_method method do |*args|
          original.bind(self).call(*args)
          self
        end
      end
    end
  end
end
