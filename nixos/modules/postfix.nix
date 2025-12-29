{ pkgs, ... }:
{
  services.postfix = {
    enable = true;
    enableSmtp = true;
    config = {
      relayhost = "[smtp.gmail.com]:587";
      smtp_sasl_auth_enable = "yes";
      smtp_sasl_password_maps = "hash:/etc/postfix/sasl_passwd";
      smtp_sasl_security_options = "";
      # smtp_tls_CAfile = "/etc/ssl/certs/ca-certificates.crt";
      smtp_use_tls = "yes";
    };
  };
}
