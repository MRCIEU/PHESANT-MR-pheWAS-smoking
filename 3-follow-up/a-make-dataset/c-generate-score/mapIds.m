

homeDir=getenv('HOME');
dir=strcat(homeDir, '/2017-PHESANT-smoking-interaction/data/');
snpDir=strcat(homeDir,'/2017-PHESANT-smoking-interaction/data/smokingscore-snps/');

bridge = dataset('file',strcat(dir,'/bridging/ukb7341.enc_ukb'),'delimiter',',');
snpscore = dataset('file',strcat(snpDir,'smokingscore.txt'),'delimiter',',');

% sort snp scores by user id 
[~,i] = sort(double(snpscore.userId));
snpscoreSort = snpscore(i,:);

% match up the ids
[~,iSnp,iPhen] = intersect(double(snpscoreSort.userId),double(bridge.app8786));
combined = [bridge(iPhen,:) snpscoreSort(iSnp,:)];

% check
format long
combined(1:10,:)                                  

% change app16729 column to eid, to match id name in phenotype file
combined.Properties.VarNames{1} = 'eid';

export(combined,'file', strcat(snpDir,'smokescore-withPhenIds.csv'), 'delimiter', ',');
