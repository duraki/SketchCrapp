var appWillFinishLaunching = ObjC.classes.MSCloudSignInViewController['- setForgotPasswordButton:'];

Interceptor.attach(appWillFinishLaunching.implementation, {
    onEnter: function (args) {
        console.log(hexdump(args));
        /**
        var notification = new ObjC.Object(args[2]);
        var notificationStr = notification.absoluteString().toString();
        console.log('Will finish launching with notification: ' + notificationStr);
        **/
    }
});
