
remote_file "#{node[:maven2][:download]}" do
  source "#{node[:maven2][:mirror]}"
  mode "0644"
  not_if do File.exists?(node[:maven2][:download]) end
end

bash "extract #{node[:maven2][:download]}" do 
  user "root"
  cwd node[:maven2][:path]
  not_if do File.exists?(node[:maven2][:home]) end
  code <<-EOH
tar xf #{node[:maven2][:download]}
EOH
end

ruby_block "env variables" do
  block do
    def write_env(file, var, val)
      if not File.read(file).match("#{var}=")
        File.open(file, 'a') {|f| f.write("#{var}=#{val}\n") }
      end
    end
    write_env("/etc/bash.bashrc", "export M2_HOME", node[:maven2][:home])
    write_env("/etc/bash.bashrc", "export PATH", "$M2_HOME/bin:$PATH")
  end
end

template "#{node[:maven2][:home]}/conf/settings.xml" do
  source "settings.xml.erb"
  mode 0755
end
