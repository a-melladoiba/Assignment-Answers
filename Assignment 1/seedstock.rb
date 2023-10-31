require 'date'

class SeedStock
    attr_accessor :seed_stock
    attr_accessor :mutant_gene
    attr_accessor :last_planted
    attr_accessor :grams_remaining
    attr_accessor :new_stock_table
  
    def initialize(seed_stock:, mutant_gene:, last_planted:, storage:, grams_remaining:)
      @seed_stock = seed_stock
      @mutant_gene = mutant_gene
      @last_planted = last_planted
      @grams_remaining = grams_remaining
      @grams_remaining = grams_remaining.to_f
      @new_stock_table = new_stock_table
    end
  
    def self.planting_seeds_and_updating_stock(stock_open, new_stock_table)
      output = File.open(new_stock_table, 'w')
      output.puts("Seed_Stock\tMutant_Gene_ID\tLast_Planted\tStorage\tGrams_Remaining")
      stock_open.each do |lines|
        seed_stock = lines.split[0]
        mutant_gene = lines.split[1]
        last_planted = lines.split[2]
        last_planted = DateTime.now.strftime('%d/%m/%Y')
        storage = lines.split[3]
        grams_remaining = lines.split[4]
        grams_remaining = grams_remaining.to_f

        # START OF PLANTING
        if grams_remaining < 7.0
          puts "WARNING: Seed Stock #{seed_stock} only has #{grams_remaining} grams of seeds. Therefore, only #{grams_remaining} grams of seed will be planted"
        end
        grams_planted = 7
        grams_planted = grams_planted.to_f
        grams_remaining -= grams_planted
        if grams_remaining <= 0.0
          puts "WARNING: we have run out of Seed Stock #{seed_stock}"
          grams_remaining = 0.0
        end

        # START OF TABLE-WRITING
        output = File.open(new_stock_table, 'a')
        output.puts("#{seed_stock}\t#{mutant_gene}\t#{last_planted}\t#{storage}\t#{grams_remaining}")
      end
    end

    def self.parent_link_2_mutant(parent:, gene_file:, stock_file:)
      stock_file.each do |lines|
        seed = lines.split[0]
        mutant = lines.split[1]
        if parent == seed
          gene_name = Gene.parent_link_2_gene(mutant: mutant, gene_file: gene_file)
          return gene_name
        end
      end
    end

    
end