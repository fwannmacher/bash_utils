cue_name=$(find . -name "*.cue")
base_name=$(basename "${cue_name}" "*.cue" | sed "s! - ! !g" | sed "s!:!!g" | perl -nle 'm/^(.*?) \(.*\).*$/; print $1')
bin_name=$(find . -name "*.bin" | sort | head -n 1)

echo "CUE NAME: [${cue_name}]"
echo "BIN NAME: [${bin_name}]"
echo "BASE NAME: [${base_name}]"

disc_number=$(echo "${cue_name}" | perl -nle 'm/^.*Disc (.?) of (.?).*$/; print "$1 - $2"')

if [[ "${disc_number}" == " - " ]]
then
	disc_number=""
else
	disc_number=" ${disc_number}"
fi

echo "DISC NUMBER: [${disc_number}]"

media_id=$(strings "${bin_name}" | grep -m 1 -oP "S[LC][UEJ]S_[0-9][0-9][0-9]\.[0-9][0-9]")

echo "MEDIA ID: [${media_id}]"

final_name=$(echo "${base_name}${disc_number} [${media_id}]")

echo "FINAL NAME: [${final_name}]"

~/bin/binmerge "${cue_name}" "${final_name}"
rm *.cue
rm *.bin
