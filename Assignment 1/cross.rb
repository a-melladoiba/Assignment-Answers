class Cross
    attr_accessor :parent1
    attr_accessor :parent2
    attr_accessor :f2_wild
    attr_accessor :f2_p1
    attr_accessor :f2_p2
    attr_accessor :f2_p1p2
    attr_accessor :chisqr #Here are stored the chisqr values
    attr_accessor :pvalue #Here are stored pvalues
  
    def initialize(parent1:, parent2:, f2_wild:, f2_p1:, f2_p2:, f2_p1p2:, pvalue: 0.05)
      @parent1 = parent1
      @parent2 = parent2
      @f2_wild = f2_wild
      @f2_wild = @f2_wild.to_f
      @f2_p1 = f2_p1
      @f2_p1 = @f2_p1.to_f
      @f2_p2 = f2_p2
      @f2_p2 = @f2_p2.to_f
      @f2_p1p2 = f2_p1p2
      @f2_p1p2 = @f2_p1p2.to_f
      @pvalue = pvalue
      @chisqr = self.chisqr_values #They are taken for a degree of freedom 3, considering that we have a sample size of 4
      self.chisqr_test
    end

    def chisqr_values
      #https://courses.wccnet.edu/~palay/math160r/chisqtable.htm
      return {
        0.999 => 0.024,
        0.995 => 0.072,
        0.990 => 0.115,
        0.975 => 0.216,
        0.950 => 0.352,
        0.900 => 0.584,
        0.100 => 6.251,
        0.050 => 7.815
      }
    end

    def chisqr_test
      observed = [self.f2_wild, self.f2_p1, self.f2_p2, self.f2_p1p2] #values to iterate in chi-square test
      expected_total = self.f2_wild + self.f2_p1 + self.f2_p2 + self.f2_p1p2
      expected_wild = expected_total * (9.0/16.0)
      expected_wild = expected_wild.to_f
      expected_p1 = expected_total * (3.0/16.0)
      expected_p1 = expected_p1.to_f
      expected_p2 = expected_total * (3.0/16.0)
      expected_p2 = expected_p2.to_f
      expected_p1p2 = expected_total * (1.0/16.0)
      expected_p1p2 = expected_p1p2.to_f
      expected = [expected_wild, expected_p1, expected_p2, expected_p1p2] #values to iterate in chi-square test

      #(observed - expected)^2 / expected
      chisquare = observed.zip(expected).map do |observed, expected|
        ((observed - expected)**2) / expected
      end.sum

      if chisquare > @chisqr[self.pvalue]
        [@parent1, @parent2].each do |parent|
          Gene.add_linked_genes(parent, chisquare)
        end
      end

      #if chisquare > @chisqr[self.pvalue]
        #@parent1.gene_id.add_linked_genes(@parent2, chisquare)
        #@parent2.gene_id.add_linked_genes(@parent1, chisquare)
        #puts "#{parent1.gene_name} gene is linked to #{parent2.gene_name}"
        #puts "#{parent2.gene_name} gene is linked to #{parent1.gene_name}"
      #end
    end
  end