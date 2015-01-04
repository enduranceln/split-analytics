module Split
  class GAExperiment

    def self.find_id(experiment)
      Split.configuration.experiments[experiment][:ga_exp_id]
    end
  end
end
