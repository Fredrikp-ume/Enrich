using PyCall
using JSON
using Pipe
using HTTP

function getSimpleResults(results,geneset="KEGG_2015") 
    @pipe results[1][geneset] |> map(r->r[2:3],_) 
end

function enrichall(userListId::Int, gene_set_libraries::Array{String,1} = ["KEGG_2015"])

    results = [enrich(userListId, gene_set_library) for gene_set_library in gene_set_libraries]
end

function enrich(userListId::Int, gene_set_library::String = "KEGG_2015")

    ENRICHR_URL = "http://amp.pharm.mssm.edu/Enrichr/enrich"
    query_string = "?userListId=$(string(userListId))&backgroundType=$(gene_set_library)"

    r = HTTP.request("GET", ENRICHR_URL * query_string)

    r.body |> String |> JSON.parse
end

function list(userListId::Int)
    ENRICHR_URL = "http://amp.pharm.mssm.edu/Enrichr/view?userListId=$(string(userListId))"

    r = HTTP.request("GET", ENRICHR_URL)

    r.body |> String |> JSON.parse
end

function addGeneList(gene_list::Array{String,1}; description)

    py"""
    import requests
    import http

    ENRICHR_URL = "http://amp.pharm.mssm.edu/Enrichr/addList"

    def query(genes_str,description):

        payload = {
            'list': (None, genes_str),
            'description': (None, description)
        }

        response = requests.post(ENRICHR_URL, files=payload)

        if not response.ok:
            raise Exception('Error analyzing gene list')

        return response.text
    """

    genes_str = join(gene_list,"\n")

    response = py"query"(genes_str, description)

    JSON.parse(response)["userListId"]
end
