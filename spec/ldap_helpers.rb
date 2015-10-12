require 'ladle'

module LdapHelpers

  def start_ldap_server
    @ldap_server = Ladle::Server.new(:quiet => true,
                                     :domain => 'dc=example,dc=org',
                                     :verbose => true,
                                     :tmpdir => Dir.tmpdir,
                                     :java_bin => ["java", "-Xmx64m"],
                                     :ldif => File.expand_path('../fixtures/tufts_ldap.ldif', __FILE__)).start
  end

  def stop_ldap_server
    @ldap_server.stop
  end
end
