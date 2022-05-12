export output_path=/var/www/inkycloud-docs
rm -rf $output_path
cd docs
retype build
mv .retype/* $output_path