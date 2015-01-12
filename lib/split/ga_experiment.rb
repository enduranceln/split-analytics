module Split
  class GAExperiment
    attr_accessor :experiment

    def initialize(name)
      name = name.split(":").first
      @experiment = Split.configuration.experiments[name]
    end

    def id
      experiment[:ga_exp_id]
    end

    def variation(name)
      name = name.split(":").first
      experiment[:alternatives].find{|x| x[:name] == name}[:ga_version]
    end
  end
end
