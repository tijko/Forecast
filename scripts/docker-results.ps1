 $id=docker images --filter "label=test-true" -q | Select-Object -First 1
 docker create --name testcontainer $id
 docker cp testcontainer:/testresults ./testresults
 docker rm testcontainer