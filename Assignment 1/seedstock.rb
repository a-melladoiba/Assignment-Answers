require 'date'

class SeedStock
    attr_accessor :seed_stock
    attr_accessor :mutant_gene
    attr_accessor :last_planted
    attr_accessor :grams_remaining

    @@stock_list = Hash.new
  
    def initialize(seed_stock:, mutant_gene:, last_planted:, storage:, grams_remaining:)
      @seed_stock = seed_stock
      @mutant_gene = mutant_gene
      @last_planted = last_planted
      @grams_remaining = grams_remaining
      @grams_remaining = grams_remaining.to_f

      @@stock_list[seed_stock] = self #Will be used to iterate on the launching script
    end

    def self.printer
        return @@stock_list
    end

    def self.find_stock_by_id(searchid: )  # This takes the parental seeds from crosses, and extract the mutant gene id for later comparison with the gene name
      @@stock_list.each do |_stockid, seed|
        return seed.mutant_gene if seed.seed_stock == searchid
      end
    end
  
    def self.planting_seeds(seed_stock, grams_planted)
      grams_remaining = seed_stock.grams_remaining
      if grams_remaining < 7.0
        puts "WARNING: Seed Stock #{seed_stock.seed_stock} only has #{grams_remaining} grams of seeds. Therefore, only #{grams_remaining} grams of seed will be planted"
      end
      grams_remaining -= grams_planted
      if grams_remaining <= 0.0
        puts "WARNING: we have run out of Seed Stock #{seed_stock.seed_stock}"
        grams_remaining = 0.0
      end
      last_planted = seed_stock.last_planted
      last_planted = DateTime.now.strftime('%d/%m/%Y')
    end
end