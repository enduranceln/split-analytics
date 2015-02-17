module Split
  class GADimension
    attr_accessor :dimension, :variation_name

    def initialize(key, variation_name)
      return if key.include?(":finished")
      @dimension = Split.configuration.experiments[key.split(":").first]
      @variation_name = variation_name
    end

    def id
      return unless dimension
      @id ||= dimension[:ga_dimension]
    end
  end
end
