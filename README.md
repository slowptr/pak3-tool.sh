# pak3-tool
a simple bash utility for unpacking/repacking `.pak3` archives (with built-in "backup protection").

## features
- **unpack**: extracts archive contents to current directory
- **pack**: repacks current directory contents to archive (renames original to `.bk`)
- automatically excludes backup archives and itself during packing

## requirements
- p7zip-full ( 7z cli )

## installation
1. install 7zip:  
   debian/ubuntu:  
   ```bash
   sudo apt install p7zip-full
   ```
   other distros: use your package manager for p7zip (i think 'nowadays' even only 7zip for most (?))

2. make script executable:
   ```bash
   chmod +x pak3-tool.sh
   ```

3. install to system path (optional):
   ```bash
   # for user-only access:
   mv pak3-tool.sh ~/.local/bin/pak3-tool

   # system-wide access:
   sudo mv pak3-tool.sh /usr/local/bin/pak3-tool
   ```

## my personal workflow
```bash
# 1. create clean working directory
mkdir .work && cd .work

# 2. unpack archive
pak3-tool unpack ../my-archive.pak3

# 3. modify contents
[... edit files ...]

# 4. repack archive
pak3-tool pack ../my-archive.pak3
```

## usage
```
pak3-tool {unpack|pack} archive.pak3
```
