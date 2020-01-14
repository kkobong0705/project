#!/bin/sh
DIR=/root/sg

while read uid groupid groupname vpcid IpPermissions FromPort CidrIp ToPort IpProtocol UserIdGroupPairs Ipv6Ranges Description
do
        if [[ "$IpPermissions" == "IpPermissionsEgress" ]];then
		if [[ "$UserIdGroupPairs" == "null" ]];then
			if [[ $IpProtocol == "-1"  ]];then
			aws ec2 update-security-group-rule-descriptions-egress --group-id $groupid \
			--ip-permissions IpProtocol=$IpProtocol,IpRanges="[{CidrIp=$CidrIp,Description=\"$Description\"}]"
			else

                	aws ec2 update-security-group-rule-descriptions-egress --group-id $groupid \
			--ip-permissions IpProtocol=$IpProtocol,FromPort=${FromPort},ToPort=${ToPort},IpRanges="[{CidrIp=$CidrIp,Description=\"$Description\"}]"
			fi
		else
			if [[ $IpProtocol == "-1"  ]];then
			aws ec2 update-security-group-rule-descriptions-egress --group-id $groupid \
			--ip-permissions IpProtocol=$IpProtocol,UserIdGroupPairs="[{GroupId=$UserIdGroupPairs,Description=\"$Description\"}]"
			else
			aws ec2 update-security-group-rule-descriptions-egress --group-id $groupid \
			--ip-permissions IpProtocol=$IpProtocol,FromPort=${FromPort},ToPort=${ToPort},UserIdGroupPairs="[{GroupId=$UserIdGroupPairs,Description=\"$Description\"}]"	       
			fi
		fi
				
        else
		if [[ "$UserIdGroupPairs" == "null" ]];then
			if [[ $IpProtocol == "-1"  ]];then
		        aws ec2 update-security-group-rule-descriptions-ingress --group-id $groupid \
			--ip-permissions IpProtocol=$IpProtocol,IpRanges="[{CidrIp=$CidrIp,Description=\"$Description\"}]"
			else
			aws ec2 update-security-group-rule-descriptions-ingress --group-id $groupid \
			--ip-permissions IpProtocol=$IpProtocol,FromPort=${FromPort},ToPort=${ToPort},IpRanges="[{CidrIp=$CidrIp,Description=\"$Description\"}]"
			fi		
		else
			if [[ $IpProtocol == "-1"  ]];then
			aws ec2 update-security-group-rule-descriptions-ingress --group-id $groupid \
			--ip-permissions IpProtocol=$IpProtocol,UserIdGroupPairs="[{GroupId=$UserIdGroupPairs,Description=\"$Description\"}]"
			else
			aws ec2 update-security-group-rule-descriptions-ingress --group-id $groupid \
			--ip-permissions IpProtocol=$IpProtocol,FromPort=${FromPort},ToPort=${ToPort},UserIdGroupPairs="[{GroupId=$UserIdGroupPairs,Description=\"$Description\"}]"
			fi
        	fi

        fi

done < $DIR/sglist.csv
