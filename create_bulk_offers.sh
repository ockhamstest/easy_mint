#!/bin/bash
read -p "Enter your fingerprint (i.e 278xxxxxxxxx) :" finger
read -p "Wallet ID for the NFTs? (i.e 5) :" id
read -p "Wallet ID for the token you request? (i.e 2) :" id2
read -p "NFT's royalty? (i.e 0.05 = 5%) :" roy; neu=$(echo "$roy+1" | bc); neu2=$(echo "scale=3 ; 1 / $neu" | bc)
echo your royalty is $roy - ergo your exchange rate to token is $neu2 tokens
read -p "how many offers do you want to create? :" num
echo ""
echo "creating NFT ID list now ..."

./chia.exe wallet nft list -f $finger -i $id | grep "nft1" >> NFT_ID_LIST.txt
echo "your NFT IDs are stored in NFT_ID_LIST.txt"

read -p "$(tput setaf 2)Do you want to continue with the auto creation of the offers? (yes/no) " yn
case $yn in
        yes ) proceed...;;
        no ) echo exiting...;
                exit;;
        * ) echo invalid response;
                exit 1;;
esac

for i in $(seq 1 $num); do
./chia.exe wallet make_offer -f $finger -o $(sed -n ${i}p NFT_ID_LIST.txt | tail -c -64 | cut -c -62):1 -r $id2:$neu2 -p offers/$i.offer &&

sleep 0.5
done
echo "$(tput setaf 3)loop closed ... your offers are saved in /offers ... Follow me on the twitter @chialisp"