--- ./tasks/install.rake.orig	2014-02-06 18:04:53.000000000 +0000
+++ ./tasks/install.rake	2014-03-06 09:20:38.000000000 +0000
@@ -16,22 +16,16 @@
   mkdir_p "#{DESTDIR}/#{@config_dir}"
   mkdir_p "#{DESTDIR}/#{@config_dir}/.."
   mkdir_p "#{DESTDIR}/#{@log_dir}"
-  mkdir_p "#{DESTDIR}/etc/init.d/"
   mkdir_p "#{DESTDIR}/#{@lib_dir}"
   mkdir_p "#{DESTDIR}/#{@libexec_dir}"
   mkdir_p "#{DESTDIR}/#{@sbin_dir}"
   mkdir_p "#{DESTDIR}/etc/logrotate.d/"
-  ln_sf @config_dir, "#{DESTDIR}/#{@lib_dir}/config"
-  ln_sf @log_dir, "#{DESTDIR}/#{@install_dir}/log"
 
   unless @pe
-    mkdir_p "#{DESTDIR}/var/lib/puppetdb/state"
-    mkdir_p "#{DESTDIR}/var/lib/puppetdb/db"
-    mkdir_p "#{DESTDIR}/var/lib/puppetdb/mq"
-    ln_sf "#{@lib_dir}/state", "#{DESTDIR}#{@link}/state"
-    ln_sf "#{@lib_dir}/db", "#{DESTDIR}#{@link}/db"
-    ln_sf "#{@lib_dir}/mq", "#{DESTDIR}#{@link}/mq"
-    mkdir_p "#{DESTDIR}/etc/puppetdb"
+    mkdir_p "#{DESTDIR}#{@lib_dir}/state"
+    mkdir_p "#{DESTDIR}#{@lib_dir}/db"
+    mkdir_p "#{DESTDIR}#{@lib_dir}/mq"
+    mkdir_p "#{DESTDIR}#{@etc_dir}"
   else
     mkdir_p "#{DESTDIR}#{@lib_dir}/state"
     mkdir_p "#{DESTDIR}#{@lib_dir}/db"
@@ -40,19 +34,15 @@
   end
 
   cp_p JAR_FILE, "#{DESTDIR}/#{@install_dir}"
-  cp_pr "ext/files/config.ini", "#{DESTDIR}/#{@config_dir}"
-  cp_pr "ext/files/database.ini", "#{DESTDIR}/#{@config_dir}"
-  cp_pr "ext/files/jetty.ini", "#{DESTDIR}/#{@config_dir}"
-  cp_pr "ext/files/repl.ini", "#{DESTDIR}/#{@config_dir}"
+  cp_pr "ext/files/config.ini", "#{DESTDIR}/#{@config_dir}/config.ini.sample"
+  cp_pr "ext/files/database.ini", "#{DESTDIR}/#{@config_dir}/database.ini.sample"
+  cp_pr "ext/files/jetty.ini", "#{DESTDIR}/#{@config_dir}/jetty.ini.sample"
+  cp_pr "ext/files/repl.ini", "#{DESTDIR}/#{@config_dir}/repl.ini.sample"
   cp_pr "ext/files/puppetdb.logrotate", "#{DESTDIR}/etc/logrotate.d/#{@name}"
   cp_pr "ext/files/log4j.properties", "#{DESTDIR}/#{@config_dir}/.."
   cp_pr "ext/files/puppetdb", "#{DESTDIR}/#{@sbin_dir}"
 
-  # Copy legacy wrapper for deprecated hyphenated sub-commands
   legacy_cmds=%w|puppetdb-ssl-setup puppetdb-foreground puppetdb-import puppetdb-export puppetdb-anonymize|
-  legacy_cmds.each do |file|
-    cp_pr "ext/files/puppetdb-legacy", "#{DESTDIR}/#{@sbin_dir}/#{file}"
-  end
 
   # Copy internal sub-commands to libexec location
   internal_cmds=legacy_cmds
@@ -93,15 +83,14 @@
     mkdir_p "#{DESTDIR}/etc/rc.d/"
     cp_p "ext/files/puppetdb.openbsd.init", "#{DESTDIR}/etc/rc.d/#{@name}.rc"
     chmod 0755, "#{DESTDIR}/etc/rc.d/#{@name}.rc"
+  elsif @osfamily == "freebsd"
+    #mkdir_p "#{DESTDIR}/usr/local/etc/rc.d/"
+    #cp_p "ext/files/puppetdb.openbsd.init", "#{DESTDIR}/etc/rc.d/#{@name}.rc"
+    #chmod 0755, "#{DESTDIR}/etc/rc.d/#{@name}.rc"
   else
     raise "Unknown or unsupported osfamily: #{@osfamily}"
   end
   chmod 0750, "#{DESTDIR}/#{@config_dir}"
   chmod 0640, "#{DESTDIR}/#{@config_dir}/../log4j.properties"
-  chmod 0700, "#{DESTDIR}/#{@sbin_dir}/puppetdb-ssl-setup"
-  chmod 0700, "#{DESTDIR}/#{@sbin_dir}/puppetdb-foreground"
-  chmod 0700, "#{DESTDIR}/#{@sbin_dir}/puppetdb-import"
-  chmod 0700, "#{DESTDIR}/#{@sbin_dir}/puppetdb-export"
-  chmod 0700, "#{DESTDIR}/#{@sbin_dir}/puppetdb-anonymize"
   chmod 0700, "#{DESTDIR}/#{@sbin_dir}/puppetdb"
 end
