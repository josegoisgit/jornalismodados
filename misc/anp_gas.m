

anp_gas_url_base = 'https://dados.gov.br/dataset/serie-historica-de-precos-de-combustiveis-por-revenda'


%%


anp_gas_html_tree = htmlTree(webread(anp_gas_url_base))

%%


anp_gas_html_tree
