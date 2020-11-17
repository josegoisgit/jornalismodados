%% Tribunal Superior Eleitoral
% Dados:
%   - Candidatos
%   - Comparecimento e abstenção
%   - Eleitorado
%   - Partidos
%   - Pesquisas eleitorais
%   - Prestação de contas eleitorais
%   - Prestação de contas partidárias
%   - Processual
%   - Resultados
%%

webTree = @(url) htmlTree(webread(url));
base_url = 'https://www.tse.jus.br/hotsites/pesquisas-eleitorais';

base_tree = htmlTree(webread(base_url));

database_tree  = base_tree.findElement('li[class=span-16]');

database_name  = database_tree.getAttribute('id');
database_href  = arrayfun(@(db) db.findElement('a').getAttribute('href'),database_tree ,'uni',0);
database_href  = cellfun(@(db) [base_url '/' db{1}], database_href,'uni',0);
database_alias = arrayfun(@(db) db.findElement('a').extractHTMLText,database_tree ,'uni',0);

clc
for d = 1: 9
    database_alias{d};
    db_tree = webTree(database_href{d});

    year_entries = db_tree.findElement('li[class=span-4]');
    year_entry = arrayfun(@(y) str2double(y.findElement('a').extractHTMLText) ,year_entries);
    year_href  = arrayfun(@(y) y.findElement('a').getAttribute('href') ,year_entries,'un',0);
    year_href  = cellfun(@(y) [base_url '/' y{1}], year_href,'un',0);

end

%%
clc
for d = 1: 9
    database_alias{d};
    db_tree = webTree(database_href{d});

    content_tree = db_tree.findElement('div[id=conteudo]');

    content_tree.findElement('a')
end

%%

url_zip = 'http://agencia.tse.jus.br/estatistica/sead/odsele/delegado_partidario/delegado_partidario.zip';

%%
clc

webTree = @(url) htmlTree(webread(url));
base_url = 'https://www.tse.jus.br/hotsites/pesquisas-eleitorais';
base_tree = webTree(base_url);

database_tree = base_tree.findElement('li[class=span-16]')

database = struct()
for dt = 1 : length(database_tree)
    database(dt).id = dt;
    database_name = database_tree(dt).getAttribute('id');
    database_alias = database_tree(dt).findElement('a').extractHTMLText;
    database_url  = database_tree(dt).findElement('a').getAttribute('href');
    
    database(dt).url = database_url{1};
    database(dt).name = database_name{1};
    database(dt).alias = database_alias{1};
end


%%

url_queue = {};


for db = 1 : length(database)
    
    db_url = [base_url  '/' database(db).url];
    db_tree = webTree(db_url);
    
    %%
    db_years = db_tree.findElement('div[class="navegacao_anos span-72"]');
    db_years = db_years.findElement('li')
    
    year_links = struct();
    
    for d = 1 : length(db_years)
       
        db_years_id = db_years(d).getAttribute('id');
        db_years_a  = db_years(d).findElement('a');
        db_years_href = db_years_a.getAttribute('href');
        db_years_alias = db_years_a.extractHTMLText;
        
        year_links(d).id    = db_years_id{1};
        year_links(d).href  = db_years_href{1};
        year_links(d).alias = db_years_alias{1};
        
        year_url = [base_url '/' year_links(d).href];
        
        year_tree = webTree(year_url);
        
        
        
        
        url_queue
        
        prepend_tree  = year_tree.findElement('div[class=prepend-1]');
        prepend_a     = year_prepend.findElement('a');
        prepend_links = struct();
        
        for a = 1 : length(prepend_a)
           link_href  = prepend_a.getAttribute('href');
           link_alias = prepend_a.extractHTMLText;
           
           prepend_links(a).href = link_href{1};
           prepend_links(a).alias = link_alias{1};
        end
        
        
        
        
        %%
        
    end
%     {year_links.href}
    %%
    
    
    content_a = db_content.findElement('a');
    
    
    
    database(db).links = year_links;
    
end

%%


webTree = @(url) htmlTree(webread(url));
base_url = 'https://www.tse.jus.br/hotsites/pesquisas-eleitorais';

base_tree = htmlTree(webread(base_url));

database_tree  = base_tree.findElement('li[class=span-16]');
database_tree  = arrayfun(@(db) db.findElement('a'),database_tree,'un',0);
database_tree  = cellfun(@(db) char(db.getAttribute('href')),database_tree,'un',0);


all_links = {};

for dt = 1 : length(database_tree)

    new_url = [base_url '/' database_tree{dt}];
    
    new_tree = webTree(new_url);
    new_content = new_tree.findElement('div[id=conteudo]');
    new_links = new_content.findElement('a');
    new_links = arrayfun(@(n) char(n.getAttribute('href')), new_links,'un',0);

    all_links = [all_links; new_links];
    
end
%%

todo_links = {};
done_links = {};
file_links = {};
what_links = {};

for a = 1 : length(all_links)
    [~,~,ext] = fileparts(strtrim(all_links{a}));
    
    switch ext
        case '.zip'
            file_links{end+1,1} = all_links{a};
        case {'.html','.htm'}
            todo_links{end+1,1} = all_links{a};
        otherwise
            what_links{end+1,1} = all_links{a};
    end
end

while (~isempty(todo_links))
    current_link = todo_links{1};
    clc
    fprintf("%i\t%s\n",length(todo_links),current_link)
    
    if ~strcmp(current_link(1:7),'http://')
        current_link = [base_url '/' current_link];
    end
    
    try
        current_html = webread(current_link);
    catch
        what_links{end+1,1} = current_link;
        todo_links(1) = [];
        continue
    end
    
    current_tree = htmlTree(current_html);
    
    prepend_tree = current_tree.findElement('div[class="prepend-1"]');
    
    prepend_a    = prepend_tree.findElement('a');
    
    prepend_href = arrayfun(@(a) char(a.getAttribute('href')),prepend_a,'un',0);
%     prepend_href
    for h = 1 : length(prepend_href)
        prepend_href{h} = strtrim(prepend_href{h});
        if ~strcmp(prepend_href{h},'http://')
           prepend_href{h} = [base_url '/' prepend_href{h}];
        end
        [~,~,ext] = fileparts(prepend_href{h});
        switch ext
            case {'.html','.htm'}
                if ~ismember(prepend_href{h},todo_links)
                    todo_links{end+1} = prepend_href{h};
                end
            case {'.zip'}
                file_links{end+1,1} = prepend_href{h};
            otherwise
                what_links{end+1,1} = all_links{a};
        end
%         if strcmp(strtrim(ext),'.zip')
%             break
%         end
    end
    
    done_links{end+1,1} = {current_link};
    todo_links(1) = [];
%     todo_links = unique(todo_links);
%     todo_links(ismember(todo_links,done_links)) = [];
end
%%

fid = fopen('tse_data_href','w+')
for f = 1 : length(file_links)
    fprintf(fid,"%s\r\n",file_links{f});
end
fclose(fid);
%%

fid = fopen('tse_broken_href','w+')
for w = 1 : length(what_links)
    fprintf(fid,"%s\r\n",what_links{w});
end
fclose(fid);

%%
clc

filenames = {}

file_folder = 'C:\Users\José Gois\Google Drive\UFRN\Jornalismo de dados\data\tse';

broken_file_link = {}
done_file_link   = {}

for f = 1 : length(file_links)

    file_link = file_links{f};

    is_http = strcmp(file_link(1:7),'http://') | strcmp(file_link(1:7),'https://');

    if ~is_http
        file_link = [base_url(8:end) '/' file_link];
    end

    [filepath,filename,fileext] = fileparts(strtrim(file_link(8:end)));

    filepath = strsplit(filepath,'/');

    filename = [filename fileext];
   
    filenames{f} = filename;
    
    try
        websave(fullfile(file_folder,filename), file_link);
        done_file_link{end+1,1} = file_link;
    catch
        broken_file_link{end+1,1} = file_link;
    end
    
end

%%








