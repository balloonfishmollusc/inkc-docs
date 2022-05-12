export output_path=/var/www/c-ink-docs
rm -rf $output_path
cd docs
retype build
mkdir $output_path
mv .retype/* $output_path