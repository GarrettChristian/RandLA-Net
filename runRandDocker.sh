

modelDirName="RandLA-Net"
modelsBaseDir="/home/garrett/Documents"
modelDir="$modelsBaseDir/$modelDirName"
dataDirRoot="/home/garrett/Documents/data/tmp/dataset"
dataDir="/home/garrett/Documents/data/tmp/dataset/sequences/00/velodyne"
predDir="/home/garrett/Documents/data/out"

container="randla-net"
image=$container"_image"


# modelRunCommand="python3 demo_folder.py " 
# modelRunCommand+="--demo-folder $dataDirRoot/sequences/00/velodyne "
# modelRunCommand+="--save-folder $predDir"

# Make sure the nn custom lib is compiled locally
modelRunCommand="sh compile_op.sh"
# Prepare the data 
modelRunCommand+=" && python3 utils/data_prepare_semantickitti.py"
modelRunCommand+=" --dataset $dataDirRoot/sequences"
# Run the model
modelRunCommand+=" && python3 -B main_SemanticKITTI.py --gpu 0 --mode test --test_area 00"
modelRunCommand+=" --dataset $dataDirRoot/sequences_0.06"
modelRunCommand+=" --model_path $modelDir/SemanticKITTI/snap-277357" 
modelRunCommand+=" --saveAt $predDir" 
# Remove the extra data
modelRunCommand+=" && rm -rf $dataDirRoot/sequences_0.06"


# Run
# container name
# Access to GPUs
# User (otherwise we won't have permission to modify files created by bind mount)
# Mount model dir
# Mount data (bins) dir
# Mount predictions (bins) dir
# image
# bash (command) 


echo 
echo $modelRunCommand
echo 
echo Running Docker $container, $image 
echo 

docker run \
--name $container \
--gpus all \
--user "$(id -u)" \
--mount type=bind,source="$modelDir",target="$modelDir" \
--mount type=bind,source="$dataDirRoot",target="$dataDirRoot" \
--mount type=bind,source="$predDir",target="$predDir" \
$image \
bash -c "cd $modelDir && $modelRunCommand"



# Clean up container
docker container stop $container && docker container rm $container




