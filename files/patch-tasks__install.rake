--- tasks/install.rake.orig	2014-08-17 18:02:57.000000000 -0700
+++ tasks/install.rake	2014-08-19 21:47:26.000000000 -0700
@@ -14,9 +14,10 @@
   @osfamily = Facter.value(:osfamily).downcase
   mkdir_p "#{DESTDIR}/#{@install_dir}"
   mkdir_p "#{DESTDIR}/#{@config_dir}"
-  mkdir_p "#{DESTDIR}/#{@config_dir}/.."
   mkdir_p "#{DESTDIR}/#{@log_dir}"
-  mkdir_p "#{DESTDIR}/etc/init.d/"
+  unless @osfamily =~ /freebsd/
+    mkdir_p "#{DESTDIR}/etc/init.d/"
+  end
   mkdir_p "#{DESTDIR}/#{@lib_dir}"
   mkdir_p "#{DESTDIR}/#{@libexec_dir}"
   mkdir_p "#{DESTDIR}/#{@sbin_dir}"
@@ -25,13 +26,10 @@
   ln_sf @log_dir, "#{DESTDIR}/#{@install_dir}/log"
 
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
@@ -40,10 +38,10 @@
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
   cp_pr "ext/files/logback.xml", "#{DESTDIR}/#{@config_dir}/.."
   cp_pr "ext/files/puppetdb", "#{DESTDIR}/#{@sbin_dir}"
@@ -100,6 +98,11 @@
     cp_p "ext/files/puppetdb.openbsd.init", "#{DESTDIR}/etc/rc.d/#{@name}.rc"
     cp_p "ext/files/puppetdb.env", "#{DESTDIR}/#{@libexec_dir}/#{@name}.env"
     chmod 0755, "#{DESTDIR}/etc/rc.d/#{@name}.rc"
+  elsif @osfamily == "freebsd"
+    #mkdir_p "#{DESTDIR}/etc/rc.d/"
+    #cp_p "ext/files/puppetdb.openbsd.init", "#{DESTDIR}/etc/rc.d/#{@name}.rc"
+    #cp_p "ext/files/puppetdb.env", "#{DESTDIR}/#{@libexec_dir}/#{@name}.env"
+    #chmod 0755, "#{DESTDIR}/etc/rc.d/#{@name}.rc"
   elsif @osfamily == "archlinux"
     #systemd!
     mkdir_p "#{DESTDIR}/etc/sysconfig"
@@ -113,10 +116,5 @@
   end
   chmod 0750, "#{DESTDIR}/#{@config_dir}"
   chmod 0640, "#{DESTDIR}/#{@config_dir}/../logback.xml"
-  chmod 0700, "#{DESTDIR}/#{@sbin_dir}/puppetdb-ssl-setup"
-  chmod 0700, "#{DESTDIR}/#{@sbin_dir}/puppetdb-foreground"
-  chmod 0700, "#{DESTDIR}/#{@sbin_dir}/puppetdb-import"
-  chmod 0700, "#{DESTDIR}/#{@sbin_dir}/puppetdb-export"
-  chmod 0700, "#{DESTDIR}/#{@sbin_dir}/puppetdb-anonymize"
   chmod 0700, "#{DESTDIR}/#{@sbin_dir}/puppetdb"
 end
