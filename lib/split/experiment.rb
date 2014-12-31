module Split
  class Experiment

    def dimension_number
      Split::Experiment.all.collect{|x| x.name}.reverse.index(name) + 1
    end

    def dimension
      Split.configuration.experiments[name][:dimension] || "dimension#{dimension_number}"
    end
  end
end
