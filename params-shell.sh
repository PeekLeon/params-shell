#!/bin/bash
declare -A PARAM

export TEXTDOMAIN=params-shell

parameter_construction(){

	declare -A PARAM_TYPE
	declare -A PARAM_NOT_NULL
	local paramError=0
	local PARAMETER
	local PARAMETER_TYPE
		
	## REGEX PARAM LIST : TYPE / NOT_NULL
	local regExParamType="(type_)([[:alnum:]]*)(=)(.*)"
	local regExParamNotNull="(not_null)(=)(.*)"
      
    ## REGEX PARAM LIST : MANDATORY
	local regExParamMandatory="(mandatory)(=)(.*)"
		
	## REGEX PARAM
	local regExParamVal="(--)(([[:alnum:]]+)([[:alnum:]_-]*)([[:alnum:]]+))(=)(.*)" # --myParam=myValue
	local regExParam="(--)(([[:alnum:]]+)([[:alnum:]_-]*)([[:alnum:]]+))" # --myParam (will be equal to 1)

	## REGEX ARRAY OF TYPES PARAMS
	declare -A aRegExParamType
	aRegExParamType[int]="^[0-9]*$"
	aRegExParamType[float]="^[0-9]*[.]?[0-9]*$"
	aRegExParamType[bool]="^[0-1]|(^[Tt][Rr][Uu][Ee]$|^[Ff][Aa][Ll][Ss][Ee]$)$"
	aRegExParamType[mail]="^([A-Za-z]+[A-Za-z0-9]*((\.|\-|\_)?[A-Za-z]+[A-Za-z0-9]*){1,})@(([A-Za-z]+[A-Za-z0-9]*)+((\.|\-|\_)?([A-Za-z]+[A-Za-z0-9]*)+){1,})+\.([A-Za-z]{2,})+"
	
	## USING THE CONFIGATION FILE TO ADD TYPES OF PARAMS
	for FIC in `ls /var/lib/params-shell/* 2>/dev/null |grep -v *.conf`;do
		local regExConfType="^([Tt][Yy][Pp][Ee]_)([a-zA-Z]*)$"
		while IFS='=' read parameter value other
		do line="$parameter $value $other"
			if [[ $parameter =~ ${regExConfType} ]];then
				aRegExParamType[${parameter:5}]=${value}
			fi
		done < "${FIC}"
	done
  
	## CONSTRUCTION OF ARRAY : PARAM_TYPE / NOT_NULL
	for myParam_Type_NotNull in "$@"; do
		if [[ $myParam_Type_NotNull =~ ${regExParamType} ]]; then
			IFS='=' read -ra splitParamType <<< "$myParam_Type_NotNull"			
			IFS=',' read -ra splitParamTypeVal <<< "${splitParamType[1]}"
			for myParamTypeVal in ${splitParamTypeVal[@]}; do
				PARAM_TYPE[$myParamTypeVal]=${splitParamType[0]:5}
			done
		elif [[ $myParam_Type_NotNull =~ ${regExParamNotNull} ]]; then
			IFS='=' read -ra splitParamNotNull <<< "$myParam_Type_NotNull"			
			IFS=',' read -ra splitParamNotNullVal <<< "${splitParamNotNull[1]}"
			for myParamTNotNullVal in ${splitParamNotNullVal[@]}; do
				PARAM_NOT_NULL[$myParamTNotNullVal]=true
			done
		fi
	done
	
	## LIST AND TEST OF PARAMS / VALUES
	for myParam in "$@"; do
		if [[ ! $myParam =~ ${regExParamType} ]] && [[ ! $myParam =~ ${regExParamNotNull} ]] && [[ ! $myParam =~ ${regExParamMandatory} ]]; then
			if [[ $myParam =~ ${regExParamVal} ]]; then
				splitParamVal[0]=$(echo $myParam | cut -d \= -f 1)
				local lengthParam=${#splitParamVal[0]}
				let "lengthParam += 1"
				splitParamVal[1]=${myParam:$lengthParam}
				PARAM[${splitParamVal[0]:2}]=${splitParamVal[1]}
	
				if [[ "${PARAM_NOT_NULL[${splitParamVal[0]:2}]}" == true && -z ${splitParamVal[1]} ]]; then
						PARAMETER=${splitParamVal[0]}
						echo $"Parameter ${PARAMETER} must not be null"
						PARAM[${splitParamVal[0]:2}]=NULL
						paramError=1
				fi
	
				if [[ ! -z "${PARAM_TYPE[${splitParamVal[0]:2}]}" ]]; then
						if [[ ! ${splitParamVal[1]} =~ ${aRegExParamType[${PARAM_TYPE[${splitParamVal[0]:2}]}]} ]]; then
								PARAMETER=${splitParamVal[0]}
								PARAMETER_TYPE=${PARAM_TYPE[${splitParamVal[0]:2}]}
								echo $"Expected type for param ${PARAMETER}: ${PARAMETER_TYPE}"
								paramError=1
						fi
				fi
				
			elif [[ $myParam =~ ${regExParam} ]]; then
				if [[ "${PARAM_NOT_NULL[${myParam:2}]}" == true ]]; then
						PARAMETER=${myParam}
						echo $"Parameter ${PARAMETER} must not be null"
						PARAM[${myParam:2}]=NULL
						paramError=1
				else
						PARAM[${myParam:2}]=1
				fi
			else
				PARAMETER=${myParam}
				echo  $"Invalid parameter: ${PARAMETER}"
				paramError=1
			fi
		fi
	done
	
	## CHECK THE MANDATORY PARAMETERS
	for myParam_Mandatory in "$@"; do
		if [[ $myParam_Mandatory =~ ${regExParamMandatory} ]]; then
			IFS='=' read -ra splitParamMandatory <<< "$myParam_Mandatory"			
			IFS=',' read -ra splitParamMandatoryVal <<< "${splitParamMandatory[1]}"
			for myParamMandatoryVal in ${splitParamMandatoryVal[@]}; do
				if [[ -z "${PARAM[$myParamMandatoryVal]}" ]]; then
					PARAMETER=$myParamMandatoryVal
					echo $"Missing parameter: ${PARAMETER}"
					paramError=1
				fi
			done
		fi
	done
	
	if [[ $paramError == 1 ]]; then
		exit 1
	fi
	
}
parameter_construction "$@"