#!/usr/local/bin/ruby

REM="#"
MOVE="mv -i"
DEL="rm -f"
DELTREE="rm -r"
Q='\''

dir1 = ARGV.shift
dir2 = ARGV.shift

if dir2.nil? 
    $stderr.print "usage: #{$0} dir1 dir2\n"
    $stderr.print "  dir1's file will be moved to dir2.\n"
    exit 1
end

dir1.gsub!(/\\/,"/")
dir2.gsub!(/\\/,"/")

# ��̃t�@�C���̃X�y�b�N���R�����g���Ƃ��ĕ\������.
def display(path1,path2)
    print "#{REM} src: #{path1}\n"
    print "#{REM}      #{File.stat(path1).size}\n"
    print "#{REM}      #{File.mtime(path1)}\n"
    print "#{REM} dst: #{path2}\n"
    print "#{REM}      #{File.stat(path2).size}\n"
    print "#{REM}      #{File.mtime(path2)}\n"
end

# 1��2���t�@�C���̃X�y�b�N��������
#   �� �d�����Ă���̂ŁA1 �̕����폜����.
def when_same(path1)
    print %Q|#{DEL} #{Q}#{path1}#{Q}\n|
end
# 2 �̃t�@�C�������݂��Ȃ���
#   �� 2 �̂̂�������̃f�B���N�g���Ɉړ�������.
def when_notexist(path1,dir2)
    if File.directory?(path1)
	print %Q|cp -r #{Q}#{path1}#{Q} #{Q}#{dir2}#{Q}/. && |
	print %Q|#{DELTREE} #{Q}#{path1}#{Q}\n|
    else
	print %Q|#{MOVE} #{Q}#{path1}#{Q} #{Q}#{dir2}#{Q}/. \n|
    end
end
# �t�@�C���̃X�y�b�N���قȂ�ꍇ�̏���
#   �� 1 �̃t�@�C�����ɓ��t�𑫂��āA2 �̃f�B���N�g���ֈړ�������.
def when_diff(path1,path2)
    stamp = File.mtime(path1).strftime("%Y%m%d%H%M%S")
    print %Q|#{MOVE} #{Q}#{path1}#{Q} #{Q}#{path2}\@#{stamp}#{Q}\n|
end

def robot(dir1,dir2)
    Dir.open(dir1) do |d|
	while fn=d.read
	    if fn == '.' || fn == ".." then
		next
	    end
	    path1 = "#{dir1}/#{fn}"
	    path2 = "#{dir2}/#{fn}"
	    print "\n"
	    if File.exist?( path2 ) then
		# �t�@�C�������݂��鎞

		if File.directory?( path1 ) && File.directory?( path2 )
		    robot( path1 , path2 );
		    next;
		end
		stat1=File.stat( path1 )
		stat2=File.stat( path2 )

		display(path1,path2)

		if  File.stat(path1).size != File.stat(path2).size ||
		    File.mtime(path1)     != File.mtime(path2) then

		    when_diff( path1 , path2 )

		else
		    # �t�@�C���͕ύX����Ă��Ȃ�.
		    when_same( path1 )
		end
	    else
		# �t�@�C�������݂��Ȃ���.
		when_notexist( path1 , dir2 );
	    end
	end
    end
end

robot(dir1,dir2)
