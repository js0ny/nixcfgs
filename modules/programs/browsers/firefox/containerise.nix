let
  rulesFor =
    container: hosts:
    map (host: {
      inherit container;
      host = "!*.${host}";
    }) hosts;
in
{
  rules = builtins.concatLists [
    (rulesFor "Academia" [ "office.com" ])
    (rulesFor "Chinese" [
      "zhihu.com"
      "bilibili.com"
      "baidu.com"
    ])
    (rulesFor "SpaceX" [
      "x.com"
      "spacex.com"
      "x.ai"
      "cursor.sh"
      "cursor.ai"
      "cursor.com"
    ])
    (rulesFor "Anthropic" [
      "anthropic.com"
      "claude.ai"
    ])
    (rulesFor "Facebook" [
      "facebook.com"
      "www.facebook.com"
      "facebook.net"
      "fb.com"
      "fb.me"
      "fbcdn.net"
      "fbcdn.com"
      "fbsbx.com"
      "tfbnw.net"
      "facebook-web-clients.appspot.com"
      "fbcdn-profile-a.akamaihd.net"
      "fbsbx.com.online-metrix.net"
      "connect.facebook.net.edgekey.net"

      "facebookrecruiting.com"
      "facebookblueprint.com"

      "fburl.com"
      "internalfb.com"

      "instagram.com"
      "cdninstagram.com"
      "instagramstatic-a.akamaihd.net"
      "instagramstatic-a.akamaihd.net.edgesuite.net"

      "messenger.com"
      "m.me"
      "messengerdevelopers.com"
      "facebook.messenger.com"

      "atdmt.com"

      "workplace.com"
      "www.workplace.com"
      "work.facebook.com"

      "onavo.com"
      "oculus.com"
      "oculusvr.com"
      "oculusbrand.com"
      "oculusforbusiness.com"

      "mapwith.ai"
      "wit.ai"
      "mapillary.com"

      "oversightboard.com"
      "www.oversightboard.com"

      "bulletin.com"
      "facebookbrand.com"

      "metacareers.com"
      "meta.com"
      "metaque.st"

      "novi.com"

      "threads.net"
      "threads.com"
    ])
  ];

}
