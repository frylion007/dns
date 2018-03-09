mkdir keys 2> /dev/dull

#views,views-update,servers
suffix="views-update"

cd keys

for key in "$@"
do
    rndc-confgen -a -r /dev/urandom -k $key -c ${key}-${suffix}.key
done

cat *-${suffix}.key > ${suffix}.key

