--- ./tasks/install.rake.orig	2013-12-07 21:25:29.203512680 -0800
+++ ./tasks/install.rake	2013-12-07 21:29:28.006489746 -0800
@@ -73,6 +73,10 @@
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
