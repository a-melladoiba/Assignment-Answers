require './annotator.rb'

class Interactor
  attr_accessor :id, :genelist, :network, :master_network, :my_genes, :kegg_annotations, :go_annotations

  def initialize(id:, genelist:)
    @id = id
    @genelist = genelist
    @network = []
    @master_network = []
    @my_genes = []
    @go_annotations = {}
    @kegg_annotations = {}
  end

  def interactions_finder(gene_id, threshold=0.5) # Threshold applied for curation of the selected connexions inside the network (and also fastens the program)
    new_genes = []
    response = Annotator.url_opener(url:"http://www.ebi.ac.uk/Tools/webservices/psicquic/intact/webservices/current/search/interactor/#{gene_id}?format=tab25")
    return new_genes unless response && !response.body.empty?

    genelist_set = Set.new(@genelist) # Convert genelist to a set for faster lookup
    response.body.each_line do |line|
      columns = line.split("\t")
      next unless columns[9] =~ /taxid:3702/ && columns[10] =~ /taxid:3702/ # Taxid for Arabidopsis
      score = columns[14].split(":")[1].to_f
      next unless score >= threshold # Curation of non-significant interactions
      colgene1 = columns[4].match(/uniprotkb:([Aa][Tt]\w[Gg]\d\d\d\d\d)/) # Code for uniprotkb id
      colgene2 = columns[5].match(/uniprotkb:([Aa][Tt]\w[Gg]\d\d\d\d\d)/)
      next unless colgene1 && colgene2 # Sometimes there is no interactions registered (skip)
      gene1 = colgene1[1].upcase
      gene2 = colgene2[1].upcase
      next if gene1 == gene2 || !genelist_set.include?(gene1) && !genelist_set.include?(gene2) # Both genes mustn't be the same, or be at the genelist
      new_genes.push(gene1 =~ /#{gene_id.upcase}/ ? gene2 : gene1)
    end
    new_genes.uniq
  end

  def networks_builder(gene_id)
    interactions_finder(gene_id).each do |id|
      next if @network.include?([gene_id, id]) || @network.include?([id, gene_id])
      @network.push([gene_id, id])
      networks_builder(id) # Recall of the function until no genes fullfill the conditions, and the code skips. It gives more complete networks
    end
    @network
  end

  def master_network
    @master_network = @network.flatten.uniq # Reduction of dimensionality
  end

  def genes_ereaser # Remove genes for not repeating genes already studied (more efficiency for the code)
    genelist_set = Set.new(@genelist)
    @my_genes = @master_network.select { |gene| genelist_set.include?(gene) }
  end

  def all_annotations
    @master_network.each do |gene|
      @go_annotations.merge!(Annotator.go_annotations_searcher(gene))
      @kegg_annotations.merge!(Annotator.kegg_annotations_searcher(gene))
    end
    @go_annotations = @go_annotations.sort
    @kegg_annotations = @kegg_annotations.sort
  end
end