new=/tmp/wwho1.$$
old=/tmp/wwho2.$$
>$old

while :
do
    who >$new
    diff $old $new
    mv $new $old
    sleep 6
done | sed '/^[^<>]/d;s/>/in  : /;s/</out : /'
