file1=$1
file2=$2
file3=$3

if [ $# -eq 3 ] && [ -e $file1 ] && [ -e $file2 ] && [ -e $file3 ]
then

echo "--------------------"
echo "OSS1 - Project1"
echo "StudentID : 12181563"
echo "Name : Seokchan Ko"
echo "--------------------"

stop="N"
until [ "$stop" = "Y" ]
do
	echo "[MENU]"
	echo "1. Get the data of Heung-Min Son's Currnt Club, Appearances, Goals, Assists in players.csv"
	echo "2. Get the team data to enter a league position in teams.csv"
	echo "3. Get the Top-3 Attendance matches in matches.csv"
	echo "4. Get the team's league position and team's top scorer in teams.csv & players.csv"
	echo "5. Get the modified format of data_GMT in matches.csv"
	echo "6. Get the data of the winning team by the largest difference on home stadium in teams.csv & matches.csv"
	echo "7. Exit"
	read -p "Enter your CHOICE(1~7) : " choice

	case "$choice" in
	1)
		read -p "Do you want to get the Heung-Min Son's data?(y/n) : " temp
		if [ $temp = "y" ]
		then
			cat players.csv | awk -F, '$1=="Heung-Min Son" {printf("Team:%s, Appearance:%d, Goal:%d, Assist:%d \n", $4, $6, $7, $8)}'
		fi;;
	2)
		read -p "What do you want to get the team data of league_position[1~20]: " position
		cat teams.csv | awk -F, -v a=$position '$6==a {printf("%d %s %f \n",a, $1, $2/($2+$3+$4))}'
		;;	
	3)
		read -p "Do you want to know Top-3 attendance data and average attendance? (y/n): " temp
		if [ $temp = "y" ]
		then
			cat matches.csv | sort -k2nr -t, | awk -F, 'NR<4 {printf("%s VS %s (%s) \n %d %s \n",$3, $4, $1, $2, $7)}'
		fi;;
	4)	
		read -p "Do you want to get each team's ranking and the highest-scoring player? (y/n): " temp
		if [ $temp = "y" ]
		then
			team=`cat teams.csv | sort -k6n -t, | awk -F, 'NR>1 {print $1}'`
			player=`cat players.csv | sort -k7nr -t, | awk -F, 'NR>1 {printf("%s,%s,%d\n", $1, $4, $7)}'`
			IFS=

			n=1
			while [ $n -lt 21 ]
			do
				cur_team=`echo $team | awk -F'\n' -v a=$n 'NR==a {print $1}'`
				echo "$n $cur_team"
				echo $player | awk -F, -v a=$cur_team '$2==a {printf("%s %d\n", $1, $3)}' | head -n 1
				echo ""
				n=$((n+1))
			done
		fi;;
	5)	
		read -p "Do you want to modifify the format of date? (y/n): " temp
		if [ $temp = "y" ]
		then
			date=`cat matches.csv | head -n 11 | awk -F, 'NR>1 {print $1}'`
			IFS=
			echo $date | sed -e 's/\s/\//1' | sed -e 's/\s/\//1' | sed -e 's/\s-\s/\//g' | awk -F'/' '{printf("%s/%s/%s %s\n", $3, $1, $2, $4)}' | sed -e 's/Aug/08/'
		fi;;
	6)	
		team=`cat teams.csv | awk -F, 'NR>1 {printf("%d) %s\n", NR-1, $1)}'`
		IFS=
		echo $team
		read -p "Enter your team number : " num

		match=`cat matches.csv | awk -F, 'NR>1 {printf("%d,%s\n", $5-$6, $0)}' | sort -k1nr -t','`
		team=`cat teams.csv | awk -F, 'NR>1 {printf("%d) %s;\n", NR-1, $1)}'`
		IFS=';'

		sel_team=`echo $team | awk -F')' -v a=$num 'NR==a {print $2}' | sed -e 's/\s//1' -e's/\s$//g'`
		max=`echo $match | awk -F, -v a=$sel_team '$4==a {print $1}' | head -n 1`

		sel_match=`echo $match | awk -F, -v a=$max '$1==a {print $0}' | awk -F, -v a=$sel_team '$4==a {printf("%s\n%s %d vs %d %s\n",$2, $4, $6, $7, $5 )}'`

		echo $sel_match;;
	7)	
		echo "Bye!\n"
		stop="Y";;
	esac
done

else
	echo "usage: ./prj1_12181563_koseokchan.sh file1 file2 file3"
fi
