
%%

organizations_base_url = 'https://dados.gov.br/organization'

web_options = weboptions;
web_options.Timeout = 60;

organizations_web = webread(organizations_base_url,web_options);
organizations_tree = htmlTree(organizations_web);

page = 1;
max_page = 2;

o = 0;
organizations = struct();

while (page < max_page)
    organizations_web  = webread([organizations_base_url '?page=' num2str(page)],web_options)
    organizations_tree = htmlTree(organizations_web);
    organization_entry = organizations_tree.findElement('li[class="media-item"]');
    
    for e = 1 : length(organization_entry)
        o = o + 1;
        organization_entry(e)
%        organization_entry(e).findElement('p')
        organization_entry(e).findElement('h3').extractHTMLText
        organizations(o).name  = char(organization_entry(e).findElement('IMG').getAttribute('alt'));
        organizations(o).alias = char(organization_entry(e).findElement('h3').extractHTMLText);
    
        organizations(o).status = 0;
    end
    
    if page == 1
        pagination = organizations_tree.findElement('div[class="pagination pagination-centered"]');
        pagination = pagination.findElement('a');
        max_page   = str2double(pagination(end-1).extractHTMLText);
    end
    
    page = page + 1;
end
%%

% f1 = @(x) x.findElement('div[class="pagination pagination-centered"]');
% pagination = @(x) (f1(x)).findElement('a');
% get_max_page = @(x) str2double((pagination(x))(end-1).extractHTMLText);



% save organizations organizations_base_url organizations

%%
clear all
load organizations
whos

web_options = weboptions;
web_options.Timeout = 360;

%%
clc


%%

clear all
load organizations.mat
load dados.mat
whos
url_base = 'https://dados.gov.br';
d = 1
%%
 
