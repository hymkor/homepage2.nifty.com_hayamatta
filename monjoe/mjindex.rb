#! ruby -Sx
=begin
    ( URL , �^�C�g�� ,���t������ )����Ȃ�z������.
=end
def mjindex(dir)
    list = []
    Dir.glob(dir + "/n[0-9][0-9].mj.idx").sort.reverse_each do |fn|
	File.open(fn,"r") do |fp|
	    uri = fn.gsub(/\.mj(\.idx)$/,'.html').split(%r|[\\\/]|)[-1]
	    while line = fp.gets
		line = Kconv.tosjis(line);
		if line =~ /^([^:]+):([^-]+)$/ then
		    dt = $1; title=$2;
		    list << [ "#{uri}\##{dt}" , title , dt ];
		end
	    end
	end
    end
    list
end
