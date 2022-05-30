$tag=$args[0]
(Get-ECRLoginCommand -Region ap-southeast-2 -ProfileName eightcap).Password | docker login --username AWS --password-stdin 447482804634.dkr.ecr.ap-southeast-2.amazonaws.com
docker build -t sync-dv-mt .
docker tag sync-dv-mt:latest 447482804634.dkr.ecr.ap-southeast-2.amazonaws.com/sync-dv-mt:$tag
docker push 447482804634.dkr.ecr.ap-southeast-2.amazonaws.com/sync-dv-mt:$tag
