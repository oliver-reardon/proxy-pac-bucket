function FindProxyForURL(url, host) {
 const PROXY = "HTTPS ingress.cloudproxy.app:443";
 const sites = [
    "my-app-service.com",
    "another-app.com",
    "third-app.example.com",
    "internal-tool.company.com"
  ];

 for (const site of sites) {
   if (shExpMatch(url, 'https://' + site + '/*') || shExpMatch(url, '*.' + site + '/*')) {
     return PROXY;
   }
 }
return 'DIRECT';
}