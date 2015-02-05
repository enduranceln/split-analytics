module Split
  class GAExperiment
    attr_accessor :experiment, :variation_name

    def initialize(key, variation_name)
      return if key.include?(":finished")
      @experiment = Split.configuration.experiments[key.split(":").first]
      @variation_name = variation_name
    end

    def id
      return unless experiment
      experiment[:ga_exp_id]
    end

    def variation
      return unless experiment
      experiment[:alternatives].find{|x| x[:name] == variation_name}[:ga_version]
    end
  end
end
