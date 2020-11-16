base_folder = 'C:\Users\José Gois\Google Drive\UFRN\Jornalismo de dados\data\anp\raw';


%%

supplier_dir = dir([base_folder filesep '*.xls'])

%%
sdata = {};
for s = 1 : length(supplier_dir)

    filename = fullfile(supplier_dir(s).folder,supplier_dir(s).name);

    fid = fopen(filename);
    data = char(fread(fid))';
    fclose(fid)

    data_tree = htmlTree(data);
    table_rows = data_tree.findElement('tr');
    table_headers = lower(cellstr(table_rows(7).findElement('td').extractHTMLText));
    table_headers = lower(regexprep(table_headers,'[^a-zA-Z]{1,1}','_'));
    table_data = arrayfun(@(entry) cellstr(entry.findElement('td').extractHTMLText),table_rows(8:end),'un',0);
    table_data = cat(2,table_data{:});


    table_data = cell2table(table_data','VariableNames',table_headers);
    
    sdata{s} = table_data;
end

%%

table_data = cat(1,sdata{:});

%%

% field = table_data.data_publica__o_dou___autoriza__o_;

field = table_data.data_de_vincula__o_a_distribuidor_;

dates = cellfun(@(f) datetime(strtrim(f),'Format','dd/MM/yyyy'),field);

%%

[count, bins, bins_center] = histdate(dates);

plot(bins_center,count)

plot(time_center,time_edge_count,'o-')

%%
for td = 1 : size(table_data,1)

    address = [ ...
    table_data(td,:).endere_o_{1} ...
    table_data(td,:).complemento_{1} ...
    table_data(td,:).bairro_{1} ...
    table_data(td,:).cep_{1} ...
    table_data(td,:).municipio_{1}(1:end-1) ...
    '/' ...
    table_data(td,:).uf_{1} ...
    'Brazil'];

fprintf('%s\n',address)

end
%%


% AVENIDA RIBEIRO DE BARROS, 45, JARDIM AEROPORTO, LONDRINA/PR CEP 86039620
