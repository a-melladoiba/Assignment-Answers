require './interactor.rb'
require './reporter.rb'

# Input: ruby main.rb ArabidopsisSubNetwork_GeneList.txt Report.txt
genelist_file, report = ARGV

puts "---------------------------------------------------"
puts "Bioinformatics Programming Challenges: ASSIGNMENT 2"
puts "---------------------------------------------------"
puts
puts "Creating genelist..."

genelist = Reporter.file_reader    (genelist_file)
genelist_clone = genelist.clone # clone for later iteration

puts
puts "Done"
puts
puts "Creating networks..."

networks_objects = []
num_gen = 0
genelist_clone.each do |gene|
    num_gen += 1
    num_total = genelist_clone.length.to_f
    status = (num_gen / num_total) * 100
    puts "0% [#{"=" * ((status.to_i)/2)}#{" " * (50-((status.to_i)/2))}] #{status.to_i}%"

    obj_net = Interactor.new(id:gene, genelist:genelist_clone)
    next if obj_net.networks_builder(gene).empty?
    networks_objects.push(obj_net)
    obj_net.master_network
    obj_net.all_annotations 
    obj_net.genes_ereaser.each { |gene| genelist_clone.delete(gene) }
end

puts
puts "Done"
puts
puts "Generating report..."

Reporter.generate_report(report, networks_objects)

puts
puts "Done"
puts "---------------------------------------------------"
puts "Finished!"
puts "---------------------------------------------------"