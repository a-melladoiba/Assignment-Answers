class Cross
    attr_accessor :parent1
    attr_accessor :parent2
    attr_accessor :f2_wild
    attr_accessor :f2_p1
    attr_accessor :f2_p2
    attr_accessor :f2_p1p2
  
    def initialize(parent1:, parent2:, f2_wild:, f2_p1:, f2_p2:, f2_p1p2:)
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
    end

    def self.chisqr_test(cross_open, stock_open, gene_open)
      cross_open.each do |lines|
        parent1 = lines.split[0]
        parent2 = lines.split[1]
        f2_wild = lines.split[2]
        f2_wild = f2_wild.to_f
        f2_p1 = lines.split[3]
        f2_p1 = f2_p1.to_f
        f2_p2 = lines.split[4]
        f2_p2 = f2_p2.to_f
        f2_p1p2 = lines.split[5]
        f2_p1p2 = f2_p1p2.to_f

        expected_total = (f2_wild) + (f2_p1) + (f2_p2) + (f2_p1p2)
        expected_total = expected_total.to_f
        expected_wild = expected_total *(9.0/16.0)
        expected_p1 = expected_total * (3.0/16.0)
        expected_p1 = expected_p1.to_f
        expected_p2 = expected_total * (3.0/16.0)
        expected_p2 = expected_p2.to_f
        expected_p1p2 = expected_total * (1.0/16.0)
        expected_p1p2 = expected_p1p2.to_f

        #(observed - expected)^2 / expected
        chisquare = ((f2_wild - expected_wild)**2/expected_wild) + ((f2_p1 - expected_p1)**2/expected_p1) + ((f2_p2 - expected_p2)**2/expected_p2) + ((f2_p1p2 - expected_p1p2)**2/expected_p1p2)

        if chisquare > 7.815 #This is the chi-square value for a p-value of 0.05, with a degrees of freedom of 3. https://courses.wccnet.edu/~palay/math160r/chisqtable.htm
          gene1 = SeedStock.parent_link_2_mutant(parent: parent1, gene_file: gene_open, stock_file: stock_open)
          gene2 = SeedStock.parent_link_2_mutant(parent: parent2, gene_file: gene_open, stock_file: stock_open)
          Gene.add_linked_genes(gene1, gene2, chisquare)
          puts "RECORDING: #{gene1} is genetically linked to #{gene2} with a score of #{chisquare}"
          puts "\t"
          puts "\t"
          puts "---------------------------------"
          puts "Final Report"
          puts "---------------------------------"
          puts "\t"
          puts "#{gene1} is linked to #{gene2}"
          puts "#{gene2} is linked to #{gene1}"
          puts "\t"
        end
      end
    end
  end