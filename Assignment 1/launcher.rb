require './backbone.rb'

gene_table, stock_table, cross_table, new_stock_table = ARGV

backbone = Backbone.new(ARGV)

backbone = backbone.launch

backbone.stock_printer.each do |_id, seed_stock|
    seed_stock.planting_seeds(seed_stock, 7.0)
end
  
  
backbone.gene_printer.each do |_gene, gene_id|
    gene_id.linked_gene do |chisquare, _chi|
        puts "#{gene_id.gene_name} is linked to #{linked_gene.gene_name} with a score of #{linked_gene.chisquare}"
    end
end
  
backbone.update_stock_table(table: new_stock_table)