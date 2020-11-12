base_folder = 'C:\Users\José Gois\Google Drive\UFRN\Jornalismo de dados\data\anp\raw';


%%

supplier_dir = dir([base_folder filesep '*.xls'])

%%

s = 10;

filename = fullfile(supplier_dir(s).folder,supplier_dir(s).name);


%%
fid = fopen(filename);
data = char(fread(fid))';
fclose(fid)

%%


data_tree = htmlTree(data);

%%

table_rows = data_tree.findElement('tr');

%%

table_headers = table_rows(7).findElement('td').extractHTMLText

%%
table_headers = table_rows(8).findElement('td').extractHTMLText

%%

AVENIDA RIBEIRO DE BARROS, 45, JARDIM AEROPORTO, LONDRINA/PR CEP 86039620
