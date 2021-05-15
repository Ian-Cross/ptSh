ver=/tmp/ptsh_ver

all:
	@echo Run \'make install\'

install:
	# List revision history from git
	# git rev-parse --short HEAD > $(ver)

	# Make the directory
	mkdir -p ~/DevLib/ptSh

	cp src/config ~/DevLib/ptSh/config
	mkdir -p ~/DevLib/ptSh/bin

	cp src/set_aliases.sh ~/DevLib/ptsh/bin/ptSh_set_aliases
	cp LICENSE ~/DevLib/ptSh/LICENSE
	cp src/logo.txt ~/DevLib/ptSh/logo.txt
	cp src/ptLs.sh ~/DevLib/ptsh/bin/ptls
	cp src/ptPwd.sh ~/DevLib/ptsh/bin/ptpwd
	cp src/ptMkdir.sh ~/DevLib/ptsh/bin/ptmkdir
	cp src/ptTouch.sh ~/DevLib/ptsh/bin/pttouch
	cp src/ptCp.sh ~/DevLib/ptsh/bin/ptcp
	cp src/ptRm.sh ~/DevLib/ptsh/bin/ptrm
	cp src/ptsh.sh ~/DevLib/ptsh/bin/ptsh

	mkdir -p ~/DevLib/ptsh/.config
	mkdir -p ~/DevLib/ptsh/.config/ptSh
	cp src/config ~/DevLib/ptsh/.config/ptSh/config

	# echo "Version: cloned from " | tee ~/.local/share/ptSh/version.txt
	# cat $(ver) | tee -a ~/.local/share/ptSh/version.txt
	
	export PATH=$$PATH:~/DevLib/ptsh/bin/ptsh

uninstall:
	rm -rf ~/.local/share/ptSh
	rm -rf ~/.config/ptSh
	rm ~/.local/bin/ptSh_set_aliases
	rm ~/.local/bin/ptls
	rm ~/.local/bin/ptpwd
	rm ~/.local/bin/ptmkdir
	rm ~/.local/bin/pttouch
	rm ~/.local/bin/ptcp
	rm ~/.local/bin/ptrm
	rm ~/.local/bin/ptsh
