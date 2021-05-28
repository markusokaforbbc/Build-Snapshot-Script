#####Script for updating agency-wires stack#####
#
#1 - Prompts the user to input Environment to use
#2 - Executes the Fetch-AWSCreds.sh for that environment#
#3 - Chooses relevant Parameter file for environment#
#4 - Creates the agency-wires stack by running the update-agency-wires-stack.sh#


##Get user input to run the Build-agency-wires-queue.sh for the Environment and prompt if incorrect##

array=( "Test" "Stage" "Live" )

function get_input() {
    read -p "${1}: " Environment
    if [[ " ${array[*]} " == *" ${Environment} "* ]]
    then
        echo "Success"
    else
        get_input 'Environment not entered correctly. Please enter either Test, Stage or Live' 
    fi
}

get_input 'Enter Environment'

##Run credentials for $Environment##

echo "Running credentials for the $Environment Environment"

cd /media/workspace/Support-Addons

./Fetch-AWSCreds.sh "$Environment"
if [ $? -ne 0 ]; then
    echo "Fetching Creds has errored - terminating script"
    exit1
fi

##Deploying stack for $Environment from agency-wires directory##

cd /media/workspace/agency-wires

echo "Creating stack for $Environment Environment"

read -p "Press enter to continue and create the agency-wires stack"

##Updating the agency-wires stack
aws cloudformation update-stack --stack-name wtnbbc-agency-wires-stack --template-body file://agency-wires.json --parameters file://agency-wires.params.${Environment,,}.json --capabilities CAPABILITY_IAM


