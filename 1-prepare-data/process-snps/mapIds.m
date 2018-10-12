dir=getenv('PROJECT_DATA');
snpDir=strcat(dir,'/snp/');

bridge = dataset('file',strcat(dir,'/bridging/ukb7341.enc_ukb'),'delimiter',',');
snpscore = dataset('file',strcat(snpDir,'snp-data.txt'),'delimiter',',');

% sort snp scores by user id 
[~,i] = sort(double(snpscore(:,1)));
snpscoreSort = snpscore(i,:);

% match up the ids
[~,iSnp,iPhen] = intersect(double(snpscoreSort(:,1)),double(bridge(:,2)));
combined = [bridge(iPhen,:) snpscoreSort(iSnp,:)];                

% check
format long
combined(1:10,:)                                  

% change app16729 column to eid, to match id name in phenotype file
combined.Properties.VarNames{1} = 'eid';

export(combined,'file', strcat(snpDir,'snp-withPhenIds.csv'), 'delimiter', ',');
