module Common
  module Hooks
    HOOKS = [:after_load]

    HOOKS.each do |hook_name|
      # define instance-level registration method per hook
      define_method hook_name do |callable = nil, &block|
        callable ||= block
        Hooks.callbacks.fetch(hook_name) << callable if callable
      end

      # define singleton-level run_* method per hook
      define_singleton_method "run_#{hook_name}" do |*args|
        callbacks.fetch(hook_name).each do |callback|
          callback.call(*args)
        end
      end
    end

    # beware, the callbacks hash is a single shared instance tied to this module
    def self.callbacks
      @callbacks ||= initialize_callbacks_array_per_hook
    end

    private

    def self.initialize_callbacks_array_per_hook
      Hash[HOOKS.map { |name| [name, []] }]
    end
  end
end
