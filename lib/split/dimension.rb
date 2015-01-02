module Split
  class Dimension

    def self.find(experiment)
      Split.configuration.experiments[experiment][:dimension] || "dimension#{number_for(experiment)}"
    end

    def number_for(experiment)
      Split::Experiment.all.collect{|x| x.name}.reverse.index(experiment) + 1
    end

  end
end
