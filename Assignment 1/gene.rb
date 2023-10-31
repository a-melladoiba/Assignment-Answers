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

    def self.gene_finder(id)
        @@gene_list.each do |gene_id, mutant_gene|
            return mutant_gene if gene_id == id
        end
    end
     
    def self.add_linked_genes(gene1, gene2, chisquare)
        @linked_gene = Hash.new
        @linked_gene[gene1] = chisquare
        @linked_gene[gene2] = chisquare
    end

    def self.parent_link_2_gene(mutant:, gene_file:)
        gene_file.each do |lines|
            id = lines.split[0]
            name = lines.split[1]
            if mutant == id
                return name
            end
        end
    end
end   