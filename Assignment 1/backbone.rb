require './gene.rb'
require './seedstock.rb'
require './cross.rb'

class Backbone
    def self.gene_opener(gene_file)
        file = File.open(gene_file, 'r')
        file.gets # Extracts the header from the table
        file.readlines.each do |lines|
            lines.strip!
            gene_id, gene_name, mutant_phenotype = lines.split("\t")
            Gene.new(
                gene_id: gene_id,
                gene_name: gene_name,
                mutant_phenotype: mutant_phenotype
            )
        end
    end

    def self.stock_opener(stock_file)
        file = File.open(stock_file, 'r')
        file.gets
        file.readlines.each do |lines|
            lines.strip!
            seed_stock, mutant_gene, last_planted, storage, grams_remaining = lines.split("\t")
            mutant_gene_id = Gene.gene_finder(mutant_gene)
            abort "ABORTING...This gene doesn't exist in the list" unless mutant_gene_id
            SeedStock.new(
                seed_stock: seed_stock,
                mutant_gene: mutant_gene_id,
                last_planted: last_planted,
                storage: storage,
                grams_remaining: grams_remaining
            )
        end
    end

    def self.cross_opener(cross_file)
        file = File.open(cross_file, 'r')
        file.gets
        file.readlines.each do |lines|
            lines.strip!
            parent1, parent2, f2_wild, f2_p1, f2_p2, f2_p1p2 = lines.split("\t")
            Cross.new(
                parent1: parent1,
                parent2: parent2,
                f2_wild: f2_wild,
                f2_p1: f2_p1,
                f2_p2: f2_p2,
                f2_p1p2: f2_p1p2
            )
        end
    end
end