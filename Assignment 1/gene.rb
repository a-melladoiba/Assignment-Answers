class Gene
    attr_accessor :gene_id
    attr_accessor :gene_name
    attr_accessor :mutant_phenotype
    attr_accessor :linked_gene

    @@gene_list = Hash.new
  
    def initialize(gene_id:, gene_name:, mutant_phenotype:)
      @gene_id = gene_id
      abort "\nInvalid Gene Id. Try again\n" unless @gene_id.match(/A[Tt]\d[Gg]\d\d\d\d\d/)
      @gene_name = gene_name
      @mutant_phenotype = mutant_phenotype
      
      @@gene_list[gene_id] = self #This will be key to append the linked genes
    end
  
    def self.printer
        return @@gene_list
    end

    def self.gene_finder(id)
        @@gene_list.each do |gene_id, mutant_gene|
            return mutant_gene if gene_id == id
        end
    end
     
    def self.add_linked_genes(parent, chisquare)
        @linked_gene = Hash.new
        @linked_gene[parent.gene_id] = chisquare
    end
end   