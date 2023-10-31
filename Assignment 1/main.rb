#One ring to rule them all, one ring to find them, one ring to bring them all, and in the darkness bind them.

require './gene.rb'
require './seedstock.rb'
require './cross.rb'
require './backbone.rb'

def main(gene_file, stock_file, cross_file, new_stock_table)
    puts "---------------------------------"
    puts "Launching the program"
    puts "---------------------------------"
    puts "\t"
    puts "\t"
    gene_open = Backbone.gene_opener(gene_file)
    puts "#{gene_file} opened successfully"
    puts "\t"
    stock_open = Backbone.stock_opener(stock_file)
    puts "#{stock_file} opened successfully"
    puts "\t"
    cross_open = Backbone.cross_opener(cross_file)
    puts "#{cross_file} opened successfully"
    puts "\t"
    puts "\t"
    puts "---------------------------------"
    puts "Planting the seeds"
    puts "---------------------------------"
    SeedStock.planting_seeds_and_updating_stock(stock_open, new_stock_table)
    puts "\t"
    puts "\t"
    puts "---------------------------------"
    puts "Performing the schi-square test"
    puts "---------------------------------"
    Cross.chisqr_test(cross_open, stock_open, gene_open)
    puts "---------------------------------"
    puts "Program finished!"
end

main(*ARGV)