module Split
  class GAExperiment
    attr_accessor :experiment, :variation_name, :name

    def initialize(key, variation_name)
      @experiment = Split.configuration.experiments[key.split(":").first]
      @variation_name = variation_name
      @name = key.split(":").first + ": " + variation_name
    end

    def id
      return unless experiment
      @id ||= experiment[:ga_exp_id]
    end

    def variation
      return unless experiment
      @variation ||= experiment[:alternatives].find{|x| x[:name] == variation_name}[:ga_version]
    end
  end
end
