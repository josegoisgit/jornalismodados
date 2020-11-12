% need to do it manual: https://postos.anp.gov.br/

dataset_url = 'https://dados.gov.br';

last_page = 495;
page = 1;


datasets = {};

while (page <= last_page)

    page_url = [dataset_url '/dataset?page=' num2str(page)];
    
    dataset_tree = htmlTree(webread(page_url));
    
    headings = dataset_tree.findElement('h3[class="dataset-heading"] > a');
    
    if page == 1
        pagination = dataset_tree.findElement('div[class="pagination pagination-centered"] > ul > li > a');
        last_page   = str2double(pagination(end-1).extractHTMLText{1});
    end
    
    if isempty(datasets)
        datasets = cell(1,495*20);
    end

    datasets(20*(page-1)+(1:20)) = arrayfun(@(h) {h.getAttribute('href'), h.extractHTMLText{1}}, headings, 'un', 0);
    
    page = page + 1;
    
end

dataset = struct();

for d = 1 : length(data)
   dataset(d).mid = d;
   dataset(d).url = data{d}{1}{1}(10:end);
   dataset(d).descriptor = data{d}{2};
end

%%

by_descriptor = @(s) arrayfun(@(d) contains(lower(d.descriptor),s), dataset, 'un', 1)
subset        = dataset(by_descriptor('preço'))

%%

dataurl  = [dataset_url '/dataset/' subset(1).url];
options  = weboptions('Timeout',60);
datatree = htmlTree(webread(dataurl,options));
headings = datatree.findElement('a[class="heading"]');

entry_url         = arrayfun(@(a) a.getAttribute('href'),headings,'un',0);
entry_description = arrayfun(@(a) a.extractHTMLText,headings,'un',0);

%%
anp_entry = struct()
for e = 1 : length(entry_url)
    anp_entry(e).url         = headings(e).getAttribute('href');
    anp_entry(e).description = headings(e).extractHTMLText;
    
    
    file_url = htmlTree(webread([dataset_url anp_entry(e).url{1}])).findElement('p[class="muted ellipsis"] > a').getAttribute('href');
    
    anp_entry(e).file_url = file_url;
end

%%
data_folder = 'C:\Users\José Gois\Google Drive\UFRN\Jornalismo de dados\data\anp'
for e = 1 : length(anp_entry)
   
    filesplit = strsplit(anp_entry(e).file_url,'/');
    
    filename = fullfile(data_folder, filesplit{end})
    
    urlwrite(anp_entry(e).file_url,filename)   
   
end

%% PARSE V2

br2double = @(br) str2double(strrep(br,',','.'));
data_folder = 'C:\Users\José Gois\Google Drive\UFRN\Jornalismo de dados\data\anp\raw';

csv_filenames = dir([data_folder filesep '*.csv']);

csv_sep = '  ';
csv_sepregex = '\s\s';
clear anp_prices
e = 0;

for c = 1  : length(csv_filenames)
    filename = fullfile(csv_filenames(c).folder  ,csv_filenames(c).name);

    fid = fopen(filename);
    data = char(fread(fid)');
    fclose(fid);

    file_lines = strsplit(data,'\r\n');

    header = strsplit(file_lines{1},csv_sep);
    header_variables = regexprep(lower(header),'[^a-z0-9]','_');
    nof_headers = length(header_variables);

    file_lines = file_lines(2:end-1);
    nof_entries = length(file_lines);
    for l = 1 : nof_entries

        if ~mod(l,1000)
            fprintf('%02.2f\t',100*l/length(file_lines))
        end

        if ~mod(l,13000)
            fprintf('\n')
        end

        line_header = file_lines{l};
        nof_characters = length(line_header);

        id_separator = regexp(line_header,csv_sepregex);
        id_separator = [-1 id_separator nof_characters+1];

        nof_separators = length(id_separator);

        entry_parts = arrayfun(@(s) line_header((id_separator(s)+2):(id_separator(s+1)-1)),1:nof_separators-1,'uni',0);
        entry_parts = cellfun(@strtrim,entry_parts,'un',0);

        entry_values = [entry_parts(1:3) cat(2,entry_parts{4:end-7}) entry_parts(end-6:end)];

        entry_values = {categorical(entry_values(1)) ...
                        categorical(entry_values(2)) ...
                        categorical(entry_values(3)) ...
                        categorical(entry_values(4)) ...
                        ordinal(num2str(entry_values{5})) ...
                        categorical(entry_values(6)) ...
                        datetime(entry_values{7},'Format','dd/MM/yyyy') ...
                        br2double(entry_values{8}) ...
                        br2double(entry_values{9}) ...
                        categorical(entry_values(10)) ...
                        categorical(entry_values(11)) };

        e = e + 1;
        anp_prices(e) = cell2struct(entry_values,header_variables,2);

    end

    proc_folder = 'C:\Users\José Gois\Google Drive\UFRN\Jornalismo de dados\data\anp\proc';



    header = {'UF','CITY','COMPANY','COMPANYCODE','PRODUCT','DATE','BOUGHT','SOLD','UNIT','FLAG'};
    fields = {'estado___sigla','munic_pio','revenda','instala__o___c_digo','produto','data_da_coleta','valor_de_compra','valor_de_venda','unidade_de_medida','bandeira'};
    types  = {'%s','%s','%s','%s','%s','%s','%.4f','%.4f','%s','%s'};


    states  = [anp_prices.estado___sigla];
    statesU = unique(states);
    for s = 1 : length(statesU)
       id_state = states == statesU(s);
       state_entries = anp_prices(id_state);

       state_folder = fullfile(proc_folder,char(statesU(s)));
       if ~exist(state_folder,'dir')
           mkdir(state_folder)
       end

       years = year([state_entries.data_da_coleta]);
       yearsU = unique(years);
       for y = 1 : length(yearsU)
           id_year = years == yearsU(y);
           year_entries = state_entries(id_year);

           months = month([year_entries.data_da_coleta]);
           monthsU = unique(months);
           for m = 1 : length(monthsU)
               id_month = months == monthsU(m);
               month_entries = year_entries(id_month);

               products  = [month_entries.produto];
               productsU = unique(products);
               for p = 1 : length(productsU)
                    id_product = products == productsU(p);
                    product_entries = month_entries(id_product);

                    file_ext = '.csv';
                    base_filename = sprintf('%s_%s_%04i_%02i',statesU(s),productsU(p),yearsU(y),monthsU(m));
                    base_path     = fullfile(state_folder, base_filename);
                    if exist([base_path file_ext],'file')
                        nof_bases = length(dir([base_path '*.csv']));
                        nof_bases = nof_bases + 2;
                        filename = sprintf('%s_%02i.csv',base_path,nof_bases);
                    else
                        filename = [base_path '.csv'];
                    end

                    fid = fopen(filename,'w+');
                    line_header = '';
                    for h = 1 : length(header)
                        if h < length(header)
                            sep = '\t';
                        else
                            sep = '\r\n';
                        end
                        entry = sprintf([header{h} sep]);
                        line_header = [line_header entry];
                    end
                    fwrite(fid,line_header);

                    for e = 1 : length(product_entries)
                        line_entry = '';
                        for h = 1 : length(header)
                            if h < length(header)
                                sep = '\t';
                            else
                                sep = '\r\n';
                            end
                            entry = sprintf([types{h} sep],product_entries(e).(fields{h}));
                            line_entry= [line_entry entry];
                        end
                        fwrite(fid,line_entry);

    %                     line_entry
                    end
                    fclose(fid);
               end
           end
       end
    end
end
%%


proc_folder = 'C:\Users\José Gois\Google Drive\UFRN\Jornalismo de dados\data\anp\proc\RN'

csv_dir = dir([proc_folder '\*GAS*.csv']);

%%

for c = 1
    filename = fullfile(csv_dir(1).folder,csv_dir(1).name);
    temp_data = readtable(filename);
end






response = webwrite(url,PostName1,PostValue1,...,PostNameN,PostValueN)





%%
[~, id_sorted] = sort([anp_prices.data_da_coleta]);
anp_prices = anp_prices(id_sorted);

%%



%%

value_diff = @(x,y) x - y;
products = categorical({'DIESEL','ETANOL','GASOLINA','GNV'});
for p = 1 : length(products)
    id_product = products(p) == [anp_prices.produto];
    
    id = id_product;
    
    sell_price  = [anp_prices(id).valor_de_venda];
    buy_price   = [anp_prices(id).valor_de_compra];
    colect_date = [anp_prices(id).data_da_coleta];

    subplot(4,1,p)
    bin = -.2:0.005:1.4;
    [count, ~] = hist(buy_price./sell_price,bin);
    
    plot(bin,log10(count))
end

%%



