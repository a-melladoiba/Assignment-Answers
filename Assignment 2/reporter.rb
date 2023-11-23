require './interactor.rb'

class Reporter
  @@genelist = []

  def self.file_reader(filename)
    return @@genelist unless @@genelist.empty?

    File.open(filename, "r") do |line|
      @@genelist = line.readlines.map { |l| l.chomp.upcase }
    end
    @@genelist
  end

  def self.generate_report(filename, networks_objects)
    open(filename,"w+") do |line|
      networks_objects.each_with_index do |net, index|
        line.puts "NETWORK #{index + 1}"
        line.puts
        line.puts "Genes connected: "
        net.network.each { |gene1, gene2| line.puts "\t#{gene1} <===> #{gene2}" }
        line.puts 

        kegg_annot = net.kegg_annotations
        if kegg_annot.empty?
          line.puts "There is no KEGG Pathways for this network."
        else
          line.puts "KEGG Pathways: "
          kegg_annot.each { |kegg_id, pathway_name| line.puts "\tID: #{kegg_id}, Pathway name: #{pathway_name}" }
        end
        line.puts

        line.puts "GO Terms: "
        net.go_annotations.each { |go_id, go_process| line.puts "\tID: #{go_id}, Biological process: #{go_process}" }
        line.puts "----------------------------------------------------------------------------------------------------------------------"
      end
    end
  end
end