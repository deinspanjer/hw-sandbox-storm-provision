# Note I'm not defining any nodes since this particular VM is a single instance box.

# A replace in file hack
# Found: http://trac.cae.tntech.edu/infrastructure/browser/puppet/modules/common/manifests/defines/replace.pp?rev=169
package { 'perl': }
define replace($file, $pattern, $replacement) {
  $pattern_no_slashes = regsubst($pattern, '/', '\\/', 'G', 'U')
  $replacement_no_slashes = regsubst($replacement, '/', '\\/', 'G', 'U')
  exec { "replace_${pattern}_${file}":
    command => "/usr/bin/perl -pi -e 's/${pattern_no_slashes}/${replacement_no_slashes}/' '${file}'",
    onlyif  => "/usr/bin/perl -ne 'BEGIN { \$ret = 1; } \$ret = 0 if /${pattern_no_slashes}/ && ! /\\Q${replacement_no_slashes}\\E/; END { exit \$ret; }' '${file}'",
    alias   => "exec_$name",
    logoutput => true,
    require => Package["perl"],
  }
}

class { "java":
  distribution => "jdk",
  version      => "latest",
}

# Clean up broken env vars Horton puts in /etc/bashrc
file_line { "etc_bashrc_java_home":
  path   => "/etc/bashrc",
  line   => "export JAVA_HOME=/usr/jdk64/jdk1.6.0_31",
  ensure => "absent",
}
file_line { "etc_bashrc_path":
  path   => "/etc/bashrc",
  line   => 'export PATH="${JAVA_HOME}bin:$PATH"',
  ensure => "absent",
}

# Set JAVA_HOME in a more appropriate place
# Can't use ${java::java_home} cause it doesn't work in the java module v1.0.1 from forge
file { "java_home":
  path    => "/etc/profile.d/java-path.sh",
  content => "export JAVA_HOME=/etc/alternatives/java_sdk_1.7.0\n",
  owner   => root,
  group   => root,
  require => Class["java"],
}

# Update all the hardcoded references to JAVA_HOME in various config/env files
$java_home_fix_line_match_defaults = {
  pattern     => 'JAVA_HOME=/usr/jdk64/jdk1\.6\.0_31',
  replacement => 'JAVA_HOME=${JAVA_HOME:-/usr/jdk64/jdk1.6.0_31}',
}
$java_home_fix_files_to_update = {
  'oozie-env.sh'     => { file => '/etc/oozie/conf.dist/oozie-env.sh' },
  'zookeeper-env.sh' => { file => '/etc/zookeeper/conf.dist/zookeeper-env.sh' },
  'yarn-env.sh'      => { file => '/etc/hadoop/conf.empty/yarn-env.sh' },
  'hadoop-env.sh'    => { file => '/etc/hadoop/conf.empty/hadoop-env.sh' },
  'hbase-env.sh'     => { file => '/etc/hbase/conf.dist/hbase-env.sh' },
  'hcat-env.sh'      => { file => '/etc/hcatalog/conf.dist/hcat-env.sh' },
  'pig-env.sh'       => { file => '/etc/pig/conf.dist/pig-env.sh' },
}
create_resources('replace', $java_home_fix_files_to_update, $java_home_fix_line_match_defaults)

include "storm_install"
->
include "kettle_storm_install"
