

Vagrant::Config.run do |config|

  config.vm.box = "w2k8"
  config.vm.box_url = "http://box.ttldev/ttl_windows-2008R2-amd64-M1D40C1-1.0.61-base.box"
  
  config.vm.boot_mode = :gui
  config.vm.share_folder "c-data-2", "cookbooks", "..\\" ,:create => true
  config.vm.share_folder "c-data-3", "cook_books", ".." ,:create => true 
  config.vm.provision :chef_solo do |chef|	
    chef.log_level         = :info
    chef.cookbooks_path = ["cookbooks", ".."] 
    chef.add_recipe("chef_handler")  	  
    chef.add_recipe("minitest-handler")
    chef.add_recipe("BuildAgentSupportingTools")
  end

  config.vm.guest = :windows
  config.vm.forward_port 3389, 3390, :name => "rdp", :auto => true
  config.vm.forward_port 5985, 5985, :name => "winrm", :auto => true
end
