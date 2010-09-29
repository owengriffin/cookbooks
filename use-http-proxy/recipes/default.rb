
puts "Proxy server = #{ENV['http_proxy']}"

script "bash proxy configuration" do
  interpreter "bash"
  user "root"
  code <<-EOH
LINE="export http_proxy=#{ENV['http_proxy']}"
FILE="/etc/bash.bashrc"
if [ -z "$(grep $LINE $FILE)" ]; then 
echo $LINE | sudo tee -a $FILE
fi
EOH
end

script "wget proxy configuration" do
  interpreter "bash"
  user "root"
  code <<-EOH
LINE="export http_proxy=#{ENV['http_proxy']}"
FILE="/etc/wgetrc"
if [ -z "$(grep $LINE $FILE)" ]; then 
echo $LINE | sudo tee -a $FILE
fi
EOH
end

script "apt proxy configuration" do
  interpreter "bash"
  user "root"
  code <<-EOH
LINE="Acquire::http::Proxy \"#{ENV['http_proxy']}\""
FILE="/etc/apt/apt.conf"
if [ -z "$(grep $LINE $FILE)" ]; then 
echo $LINE | sudo tee -a $FILE
fi
EOH
end
