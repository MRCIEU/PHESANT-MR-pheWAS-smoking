



%%%%%%%%%%%%
% read data

datadir=getenv('PROJECT_DATA');
smoking = dataset('file', strcat(datadir, '/phenotypes/derived/data.21753-phesant_header-20116.csv'), 'delimiter', ',');

snpdir=strcat(datadir, '/snp/');
snp = dataset('file', strcat(snpdir, 'snp-withPhenIds-subset.csv'), 'delimiter', ',');

all = join(snp, smoking, 'keys', 'eid', 'type', 'inner', 'MergeKeys', true);

%%%%%%%%%%%
% find never and ever 

never = find(all.x20116_0_0 == 0);
ever = find(all.x20116_0_0 == 1 | all.x20116_0_0 == 2);


%%%%%%%%%%
% make datasets

neverData = all(never, {'eid', 'rs16969968'});
export(neverData, 'file', strcat(snpdir, 'snp-never.csv'), 'delimiter', ',');

everData = all(ever, {'eid', 'rs16969968'});
export(everData, 'file', strcat(snpdir, 'snp-ever.csv'), 'delimiter', ',');


