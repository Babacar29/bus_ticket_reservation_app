// ignore_for_file: file_names

const Map<String, dynamic> appLanguageLabelKeys = /*{
  "somethingMSg": "Something went wrong. Please try again after some time",
  "bookmarkLbl": "Bookmarks",
  "loginLbl": "Login",
  "welTitle1": "Restez informé",
  "welTitle2": "Et Partagez",
  "welTitle3": "News Categories",
  "welDes1": "Pour ètre à jour sur le programme du parti REEW MI",
  "welDes2": "N'hésitez pas à en parler au tour de vous",
  "welDes3": "Get Filtered News of Your Choice",
  "nameLbl": "Name",
  "emailLbl": "Email",
  "passLbl": "Password",
  "confpassLbl": "Confirm Password",
  "priPolicy": "Privacy Policy",
  "andLbl": " and ",
  "termLbl": "Terms of Service",
  "forgotPassLbl": "Forgot Password ?",
  "internetmsg": "Internet Connection not available",
  "loginMsg": "Login Successfully",
  "loginNowLbl": "Login Now",
  "logoutLbl": "Logout",
  "cancelBtn": "Cancel",
  "noNews": "News Not Available",
  "exitWR": "Double tap back button to exit",
  "shareLbl": "Share",
  "deactiveMsg": "You are deactivated by admin",
  "bookmarkNotAvail": "Bookmarks Not Available",
  "notiNotAvail": "Notifications Not Available",
  "notificationLbl": "Notifications",
  "logoutTxt": "Are you sure you want to logout?",
  "yesLbl": "Yes",
  "noLbl": "No",
  "frgtPassHead": "Enter the email address associated with your account",
  "forgotPassSub": "We will email you a link to reset your password",
  "submitBtn": "Submit",
  "verifyEmailMsg": "Please first verify your email address!!!",
  "passReset": "Password reset link has been sent to your mail",
  "profileUpdateMsg": "Profile Data Updated Successfully",
  "bookmarkLogin": "Please Login to Access Your Bookmarks !!",
  "preferenceSave": "Your preference saved!!",
  "managePreferences": "Manage Preferences",
  "loginReqMsg": "Login Required...",
  "firstFillData": "Please First Fill Data!...",
  "deleteTxt": "Delete",
  "reportTxt": "Report",
  "nameRequired": "Name is Required",
  "nameLength": "Name should be atleast 2 character long",
  "emailRequired": "email address is Required",
  "emailValid": "Please enter a valid email Address!",
  "pwdRequired": "Password is Required",
  "confPassRequired": "Confirm Password is Required",
  "confPassNotMatch": "Confirm Password not match",
  "photoLibLbl": "Photo Library",
  "cameraLbl": "Camera",
  "verifSentMail": "Verification email sent to ",
  "cancelLogin": "Login cancelled by the user.",
  "loginTxt": "Log In",
  "loginBtn": "Login",
  "signupBtn": "Sign Up",
  "otpVerifyLbl": "OTP\nVerification",
  "enterMblLbl": "Enter Your Mobile Number",
  "receiveDigitLbl": "You'll Receive 6 digit code for phone number verification",
  "reqOtpLbl": "Request OTP",
  "otpSentLbl": "OTP has been sent to ",
  "resendCodeLbl": "Resend Code in",
  "mobileLbl": "Mobile",
  "darkModeLbl": "Dark Mode",
  "changeLang": "Change Language",
  "rateUs": "Rate Us",
  "shareApp": "Share App",
  "weatherLbl": "Weather Forecast",
  "categoryLbl": "Categories",
  "allLbl": "All",
  "comLbl": "Comment ",
  "saveLbl": "Save",
  "txtSizeLbl": "Text Size",
  "speakLoudLbl": "Speak Loud",
  "likeLbl": "likes",
  "comsLbl": "Comments",
  "shareThoghtLbl": "Share Your Thoughts.",
  "replyLbl": "Replies",
  "publicReply": "Add a public reply...",
  "personalLbl": "Personal",
  "newsLbl": "Info",
  "plzLbl": "Please",
  "fastTrendNewsLbl": "Programme REEW MI ",
  "enterOtpTxt": "Please Enter OTP",
  "otpError": "Error validating OTP, try again",
  "otpMsg": "OTP verified successfully",
  "resendLbl": "Resend OTP",
  "otpTimeoutLbl": "Otp Retrieval Timeout!!!",
  "mblRequired": "Mobile number is Required",
  "mblValid": "Please enter a valid mobile number!",
  "codeSent": "Code Sent Successfully!!!",
  "relatedNews": "You might also like",
  "optSel": "Please Select One Option!!!",
  "madeBy": "Made by",
  "skip": "Passer",
  "nxt": "Suivant",
  "signInTab": "Sign In",
  "agreeTermPolicyLbl": "By Logging In, you agree to our",
  "agreeTCFirst": "Please Agree to our Privacy Policy first !!",
  "addTCFirst": "Please Ask Admin to Add Privacy Policy & Terms and Conditions first !!",
  "orLbl": "or Log In with",
  "signupDescr": "Create\nan Account",
  "firstAccLbl": "First to access",
  "allFunLbl": "all Functions",
  "chooseLanLbl": "Select Language",
  "videosLbl": "Videos",
  "search": "Search",
  "searchHomeNews": "Search News, Categories, etc.",
  "viewMore": "View More",
  "viewFullCoverage": "View full Coverage",
  "updateName": "Update your Name",
  "loginDescr": "Let's Sign \nYou In",
  "deleteAcc": "Delete Account",
  "deleteAlertTitle": "Re-Login",
  "deleteRelogin": "To Delete your Account, You need to Login again.\nAfter that you will be able to Delete your Account.",
  "deleteConfirm": "Are you sure?\nDo You Really Want to Delete Your Account?",
  "pwdLength": "Password should be more than 6 character long",
  "userNotFound": "No user found for that email.",
  "wrongPassword": "Wrong password provided for that user.",
  "weakPassword": "The password provided is too weak.",
  "emailAlreadyInUse": "The account already exists for that email.",
  "invalidPhoneNumber": "The provided phone number is not valid.",
  "invalidVerificationCode": "The sms verification code used to create the phone auth credential is invalid.",
  "shareMsg": "You can find our app from below url",
  "ago": "ago",
  "minutes": "minutes",
  "seconds": "seconds",
  "hours": "hours",
  "days": "days",
  "justNow": "just now",
  "about": "about",
  "liveVideosLbl": "Live Videos",
  "stdPostLbl": "Standard Post",
  "videoYoutubeLbl": "Video (Youtube)",
  "videoOtherUrlLbl": "Video (Other Url)",
  "videoUploadLbl": "Video (Upload)",
  "createNewsLbl": "Create News",
  "step1Of2Lbl": "Step 1 of 2",
  "catLbl": "Category",
  "plzSelCatLbl": "Please select category",
  "subcatLbl": "SubCategory",
  "contentTypeLbl": "Content Type",
  "uploadVideoLbl": "Upload Video",
  "youtubeUrlLbl": "Youtube Url",
  "otherUrlLbl": "Other Url",
  "selContentTypeLbl": "Select Content Type",
  "titleLbl": "Title",
  "tagLbl": "Tag",
  "showTilledDate": "Show Till Date",
  "uploadMainImageLbl": "Upload Main Image",
  "uploadOtherImageLbl": "Upload Other Image",
  "plzUploadVideoLbl": "Please upload video!!!",
  "plzAddMainImageLbl": "Please add main image!!!",
  "selTagLbl": "Select Tag",
  "selSubCatLbl": "Select Sub Category",
  "selCatLbl": "Select Category",
  "editNewsLbl": "Edit News",
  "editLbl": "Edit",
  "doYouReallyNewsLbl": "Do You Really Want to Delete this News?",
  "delNewsLbl": "Delete News",
  "newsTitleReqLbl": "News title is required!!!",
  "plzAddValidTitleLbl": "Please add valid news title!!!",
  "urlReqLbl": "Url is required!!!",
  "plzValidUrlLbl": "Please add valid url!!!",
  "manageNewsLbl": "Manage News",
  "step2of2Lbl": "Step 2 of 2",
  "descLbl": "Description",
  "RetryLbl": "Retry",
  "previewLbl": "Preview",
  "sponsoredLbl": "Sponsored",
  "searchForLbl": "Search Result for",
  "readLessLbl": "Read less",
  "readMoreLbl": "Read more",
  "myProfile": "My Profile",
  "noComments": "Be the First One to Comment !!!",
  "minute": "minute",
  "read": "read"
}*/{
  "somethingMSg": "Quelque chose s'est mal passé. Veuillez réessayer après un certain temps",
  "bookmarkLbl": "Favoris",
  "loginLbl": "Se connecter",
  "welTitle1": "Restez informé",
  "welTitle2": "Et Partagez",
  "welTitle3": "Catégories d'actualités",
  "welDes1": "Pour ètre à jour sur le programme du parti REEW MI",
  "welDes2": "N'hésitez pas à en parler au tour de vous",
  "welDes3": "Obtenez des actualités filtrées selon vos préférences",
  "nameLbl": "Nom",
  "emailLbl": "E-mail",
  "passLbl": "Mot de passe",
  "confpassLbl": "Confirmer le mot de passe",
  "priPolicy": "Politique de confidentialité",
  "andLbl": " et ",
  "termLbl": "Conditions d'utilisation",
  "forgotPassLbl": "Mot de passe oublié ?",
  "internetmsg": "Connexion Internet non disponible",
  "loginMsg": "Connexion réussie",
  "loginNowLbl": "Se connecter maintenant",
  "logoutLbl": "Se déconnecter",
  "cancelBtn": "Annuler",
  "noNews": "Actualités non disponibles",
  "exitWR": "Appuyez deux fois sur le bouton retour pour quitter",
  "shareLbl": "Partager",
  "deactiveMsg": "Vous avez été désactivé par l'administrateur",
  "bookmarkNotAvail": "Favoris non disponibles",
  "notiNotAvail": "Notifications non disponibles",
  "notificationLbl": "Notifications",
  "logoutTxt": "Êtes-vous sûr de vouloir vous déconnecter ?",
  "yesLbl": "Oui",
  "noLbl": "Non",
  "frgtPassHead": "Entrez l'adresse e-mail associée à votre compte",
  "forgotPassSub": "Nous vous enverrons un lien pour réinitialiser votre mot de passe par e-mail",
  "submitBtn": "Soumettre",
  "verifyEmailMsg": "Veuillez d'abord vérifier votre adresse e-mail !!!",
  "passReset": "Le lien de réinitialisation du mot de passe a été envoyé à votre adresse e-mail",
  "profileUpdateMsg": "Données du profil mises à jour avec succès",
  "bookmarkLogin": "Veuillez vous connecter pour accéder à vos favoris !!",
  "preferenceSave": "Vos préférences ont été enregistrées !!",
  "managePreferences": "Gérer les préférences",
  "loginReqMsg": "Connexion requise...",
  "firstFillData": "Veuillez d'abord remplir les données !...",
  "deleteTxt": "Supprimer",
  "reportTxt": "Signaler",
  "nameRequired": "Le nom est requis",
  "nameLength": "Le nom doit comporter au moins 2 caractères",
  "emailRequired": "L'adresse e-mail est requise",
  "emailValid": "Veuillez saisir une adresse e-mail valide !",
  "pwdRequired": "Le mot de passe est requis",
  "confPassRequired": "La confirmation du mot de passe est requise",
  "confPassNotMatch": "La confirmation du mot de passe ne correspond pas",
  "photoLibLbl": "Bibliothèque de photos",
  "cameraLbl": "Appareil photo",
  "verifSentMail": "E-mail de vérification envoyé à ",
  "cancelLogin": "Connexion annulée par l'utilisateur.",
  "loginTxt": "Se connecter",
  "loginBtn": "Se connecter",
  "signupBtn": "S'inscrire",
  "otpVerifyLbl": "Vérification\nOTP",
  "enterMblLbl": "Entrez votre numéro de téléphone mobile",
  "receiveDigitLbl": "Vous recevrez un code à 6 chiffres pour la vérification du numéro de téléphone",
  "reqOtpLbl": "Demander un OTP",
  "otpSentLbl": "L'OTP a été envoyé à ",
  "resendCodeLbl": "Renvoyer le code dans",
  "mobileLbl": "Mobile",
  "darkModeLbl": "Mode sombre",
  "changeLang": "Changer de langue",
  "rateUs": "Évaluez-nous",
  "shareApp": "Partager l'application",
  "weatherLbl": "Prévisions météorologiques",
  "categoryLbl": "Catégories",
  "allLbl": "Tout",
  "comLbl": "Commentaire ",
  "saveLbl": "Enregistrer",
  "txtSizeLbl": "Taille du texte",
  "speakLoudLbl": "Parlez fort",
  "likeLbl": "j'aime",
  "comsLbl": "Commentaires",
  "shareThoghtLbl": "Partagez vos pensées",
  "replyLbl": "Réponses",
  "publicReply": "Ajouter une réponse publique...",
  "personalLbl": "Personnel",
  "newsLbl": "Infos",
  "plzLbl": "Veuillez cliquer sur ",
  "fastTrendNewsLbl": "Parti REEW MI",
  "enterOtpTxt": "Veuillez entrer l'OTP",
  "otpError": "Erreur de validation de l'OTP, réessayez",
  "otpMsg": "OTP vérifié avec succès",
  "resendLbl": "Renvoyer l'OTP",
  "otpTimeoutLbl": "Délai de récupération de l'OTP dépassé !!!",
  "mblRequired": "Le numéro de téléphone mobile est requis",
  "mblValid": "Veuillez saisir un numéro de téléphone mobile valide !",
  "codeSent": "Code envoyé avec succès !!!",
  "relatedNews": "Vous pourriez aussi aimer",
  "optSel": "Veuillez sélectionner une option !!!",
  "madeBy": "Créé par",
  "skip": "Passer",
  "nxt": "Suivant",
  "signInTab": "Se connecter",
  "agreeTermPolicyLbl": "En vous connectant, vous acceptez notre",
  "agreeTCFirst": "Veuillez d'abord accepter notre politique de confidentialité !!",
  "addTCFirst": "Veuillez demander à l'administrateur d'ajouter d'abord la politique de confidentialité et les conditions générales !!",
  "orLbl": "ou se connecter avec",
  "signupDescr": "Créer\nun compte",
  "firstAccLbl": "pour accéder à toutes les fonctionnalités",
  "allFunLbl": "toutes les fonctionnalités",
  "chooseLanLbl": "Sélectionner la langue",
  "videosLbl": "Vidéos",
  "search": "Rechercher",
  "searchHomeNews": "Rechercher des actualités, des catégories, etc.",
  "viewMore": "Voir plus",
  "viewFullCoverage": "Voir la couverture complète",
  "updateName": "Mettre à jour votre nom",
  "loginDescr": "Connectons\nVous",
  "deleteAcc": "Supprimer le compte",
  "deleteAlertTitle": "Réconnexion",
  "deleteRelogin": "Pour supprimer votre compte, vous devez vous reconnecter. Ensuite, vous pourrez supprimer votre compte.",
  "deleteConfirm": "Êtes-vous sûr ?\nVoulez-vous vraiment supprimer votre compte ?",
  "pwdLength": "Le mot de passe doit comporter plus de 6 caractères",
  "userNotFound": "Aucun utilisateur trouvé pour cette adresse e-mail.",
  "wrongPassword": "Mot de passe incorrect fourni pour cet utilisateur.",
  "weakPassword": "Le mot de passe fourni est trop faible.",
  "emailAlreadyInUse": "Un compte existe déjà pour cette adresse e-mail.",
  "invalidPhoneNumber": "Le numéro de téléphone fourni n'est pas valide.",
  "invalidVerificationCode": "Le code de vérification SMS utilisé pour créer l'authentification par téléphone est invalide.",
  "shareMsg": "Vous pouvez trouver notre application à partir de l'URL suivante",
  "ago": "il y a",
  "minutes": "minutes",
  "seconds": "secondes",
  "hours": "heures",
  "days": "jours",
  "justNow": "à l'instant",
  "about": "environ",
  "liveVideosLbl": "Vidéos en direct",
  "stdPostLbl": "Article standard",
  "videoYoutubeLbl": "Vidéo (YouTube)",
  "videoOtherUrlLbl": "Vidéo (autre URL)",
  "videoUploadLbl": "Vidéo (Téléchargement)",
  "createNewsLbl": "Créer une actualité",
  "step1Of2Lbl": "Étape 1 sur 2",
  "catLbl": "Catégorie",
  "plzSelCatLbl": "Veuillez sélectionner une catégorie",
  "subcatLbl": "Sous-catégorie",
  "contentTypeLbl": "Type de contenu",
  "uploadVideoLbl": "Télécharger une vidéo",
  "youtubeUrlLbl": "URL YouTube",
  "otherUrlLbl": "Autre URL",
  "selContentTypeLbl": "Sélectionner le type de contenu",
  "titleLbl": "Titre",
  "tagLbl": "Étiquette",
  "showTilledDate": "Afficher jusqu'à la date",
  "uploadMainImageLbl": "Télécharger une image principale",
  "uploadOtherImageLbl": "Télécharger d'autres images",
  "plzUploadVideoLbl": "Veuillez télécharger une vidéo !!!",
  "plzAddMainImageLbl": "Veuillez ajouter une image principale !!!",
  "selTagLbl": "Sélectionner une étiquette",
  "selSubCatLbl": "Sélectionner une sous-catégorie",
  "selCatLbl": "Sélectionner une catégorie",
  "editNewsLbl": "Modifier l'actualité",
  "editLbl": "Modifier",
  "doYouReallyNewsLbl": "Voulez-vous vraiment supprimer cette actualité ?",
  "delNewsLbl": "Supprimer l'actualité",
  "newsTitleReqLbl": "Le titre de l'actualité est requis !!!",
  "plzAddValidTitleLbl": "Veuillez ajouter un titre d'actualité valide !!!",
  "urlReqLbl": "URL requise !!!",
  "plzValidUrlLbl": "Veuillez ajouter une URL valide !!!",
  "manageNewsLbl": "Gérer les actualités",
  "step2of2Lbl": "Étape 2 sur 2",
  "descLbl": "Description",
  "RetryLbl": "Réessayer",
  "previewLbl": "Aperçu",
  "sponsoredLbl": "Sponsorisé",
  "searchForLbl": "Résultats de recherche pour",
  "readLessLbl": "Lire moins",
  "readMoreLbl": "Lire plus",
  "myProfile": "Mon profil",
  "noComments": "Soyez le premier à commenter !!!",
  "minute": "minute",
  "read": "lire"
};
