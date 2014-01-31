# Note I'm not defining any nodes since this particular VM is a single instance box.

# A replace in file hack
# Found: http://trac.cae.tntech.edu/infrastructure/browser/puppet/modules/common/manifests/defines/replace.pp?rev=169
define replace($file, $pattern, $replacement) {
$pattern_no_slashes = regsubst($pattern, '/', '\\/', 'G', 'U')
$replacement_no_slashes = regsubst($replacement, '/', '\\/', 'G', 'U')
exec { "replace_${pattern}_${file}":
	command => "/usr/bin/perl -pi -e 's/${pattern_no_slashes}/${replacement_no_slashes}/' '${file}'",
	onlyif  => "/usr/bin/perl -ne 'BEGIN { \$ret = 1; } \$ret = 0 if /${pattern_no_slashes}/ && ! /\\Q${replacement_no_slashes}\\E/; END { exit \$ret; }' '${file}'",
	alias   => "exec_$name",
	require => Package["perl"],
}
}

class { "java":
  distribution => "jdk",
  version      => "latest",
}

# Clean up broken env vars Horton puts in /etc/bashrc
file_line { "/etc/bashrc":
  line   => "export JAVA_HOME=/usr/jdk64/jdk1.6.0_31",
  ensure => "absent",
}
file_line { "/etc/bashrc":
  line   => 'export PATH="${JAVA_HOME}bin:$PATH"',
  ensure => "absent",
}

#include "storm-install"
#include "kettle-storm-install"
