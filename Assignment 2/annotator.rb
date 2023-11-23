require 'rest-client'
require 'json'

class Annotator
  # This function of the code was written with the help of Bioinformatic Challenges Lesson 4, and Bing Chat-GPT4.
  def self.url_opener(url:, headers: {accept: "*/*"})
    RestClient::Request.execute({
      method: :get,
      url: url.to_s
    })
  rescue RestClient::ExceptionWithResponse, RestClient::Exception, Exception => e
    $stderr.puts e.inspect
    false
  end

  def self.kegg_annotations_searcher(gene_id)
    response = url_opener(url:"http://togows.org/entry/kegg-genes/ath:#{gene_id}/pathways.json")
    return {} unless response

    res_kegg_hash = JSON.parse(response.body)[0] # for turning JSON intro ruby files (Lesson 4)
    res_kegg_hash.nil? ? {} : res_kegg_hash
  end

  def self.go_annotations_searcher(gene_id)
    response = url_opener(url:"http://togows.org/entry/ebi-uniprot/#{gene_id}/dr.json")
    return {} unless response

    res_go_hash = JSON.parse(response.body)[0]
    return {} if res_go_hash["GO"].nil?

    res_go_hash["GO"].each_with_object({}) do |go_info, go_hash|
      if go_info[1] =~ /^P:/ # pattern for the process
        go_id = go_info[0]
        go_process = go_info[1].split(":")[1]
        go_hash[go_id] = go_process
      end
    end
  end
end