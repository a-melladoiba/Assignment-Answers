require './gene.rb'
require './seedstock.rb'
require './cross.rb'

class Backbone
    attr_accessor :gene_header
    attr_accessor :stock_header
    attr_accessor :cross_header
    attr_accessor :gene_table
    attr_accessor :stock_table
    attr_accessor :cross_table
    def initialize(args)
        @gene_table = args[0]
        @stock_table = args[1]
        @cross_table = args[2]
    end
    
    def launch
        self.gene_opener(gene_table: @gene_table)
        self.stock_opener(stock_table: @stock_table)
        self.cross_opener(cross_table: @cross_table)
    end

    def gene_opener(gene_table:)
        file = File.open(gene_table, 'r')
        @gene_header = file.gets  # read first line, capture it into a variable for later writing
        file.readlines.each do |line|
            line.strip!
            gene_id, gene_name, mutant_phenotype = line.split("\t")
            _gene = Gene.new(
                gene_id: gene_id,
                gene_name: gene_name,
                mutant_phenotype: mutant_phenotype
            )
        end
    end

    def stock_opener(stock_table:)
        file = File.open(stock_table, 'r')
        @stock_header = file.gets   # read first line, capture it into a variable for later writing
        
        file.readlines.each do |line|
            line.strip!
            seed_stock, mutant_gene, last_planted, storage, grams_remaining = line.split("\t")
            mutant_gene_id = Gene.gene_finder(mutant_gene)  # look up the gene object by its id
            abort "ABORTING...This gene doesn't exist in the list" unless mutant_gene_id
            _stock = SeedStock.new(
                seed_stock: seed_stock,
                mutant_gene: mutant_gene_id,
                last_planted: last_planted,
                storage: storage,
                grams_remaining: grams_remaining
            )
        end
    end

    def cross_opener(cross_table:)
        file = File.open(cross_table, 'r')
        @cross_header = file.gets   # read first line
        
        file.readlines.each do |line|
            line.strip!
            parent1, parent2, f2_wild, f2_p1, f2_p2, f2_p1p2 = line.split("\t")
            parent1_gene = SeedStock.find_stock_by_id(searchid: parent1) # get the Gene object associated with each stock
            parent2_gene = SeedStock.find_stock_by_id(searchid: parent2) # get the Gene object associated with each stock
            _cross = Cross.new(  # this will also execute the chisquare
                parent1: parent1_gene,
                parent2: parent2_gene,
                f2_wild: f2_wild,
                f2_p1: f2_p1,
                f2_p2: f2_p2,
                f2_p1p2: f2_p1p2
            )
        end
    end

    def update_stock_table(table:)
        out = File.open(table, 'w')
        out.puts(@stock_header)  # we capturd this header when we read the file
  
        SeedStock.printer.each do |_stockid, seed_stock|
            out.puts([seed_stock.seed_stock, seed_stock.mutant_gene.gene_id, seed_stock.last_planted, seed_stock.grams_remaining].join("\t"))
        end
        puts "New seed_stock table finished"    
    end

    def self.stock_printer
        return SeedStock.printer #Brings the list of seed_stock from Seed Stock tsv
    end

    def self.gene_printer
        return Gene.printer
    end
end