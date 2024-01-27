// ignore_for_file: file_names

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../utils/uiUtils.dart';
import '../styles/colors.dart';
import '../widgets/myAppBar.dart';
import 'Tickets/TicketsScreen.dart';
import 'Profile/ProfileScreen.dart';

class PrivacyPolicy extends StatefulWidget {
  final String? title;
  final String? from;
  final String? desc;

  const PrivacyPolicy({Key? key, this.title, this.from, this.desc}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return StatePrivacy();
  }

  static Route route(RouteSettings routeSettings) {
    final arguments = routeSettings.arguments as Map<String, dynamic>;
    return CupertinoPageRoute(
        builder: (_) => PrivacyPolicy(
              from: arguments['from'],
              title: arguments['title'],
              desc: arguments['desc'],
            ));
  }
}

class StatePrivacy extends State<PrivacyPolicy> with TickerProviderStateMixin {
  int _selectedIndex = 0;
  List<IconData> iconList = [
    Icons.bookmark,
    Icons.bookmark,
    Icons.account_circle,
  ];
  List<Widget> fragments = [];


  Widget buildNavBarItem(IconData icon, int index) {
    return InkWell(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      child: Container(
        height: 60,
        width: MediaQuery.of(context).size.width / iconList.length,
        decoration: index == _selectedIndex
            ? const BoxDecoration(
          border: Border(
            top: BorderSide(width: 3, color: darkBackgroundColor),
          ),
        )
            : null,
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: Column(
            children: [
              Icon(
                icon,
                color: index == _selectedIndex ? darkBackgroundColor : UiUtils.getColorScheme(context).outline,
              ),
              index == 0 ? Text(
                "Réservations",
                style: TextStyle(
                    color: index == _selectedIndex ? darkBackgroundColor : null
                ),
              ) : const SizedBox(),
              index == 1 ? Text(
                "Mes billets",
                style: TextStyle(
                    color: index == _selectedIndex ? darkBackgroundColor : null
                ),
              ) : const SizedBox(),
              index == 2 ? Text(
                "Mon Compte",
                style: TextStyle(
                    color: index == _selectedIndex ? darkBackgroundColor : null
                ),
              ) : const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }

  bottomBar() {
    List<Widget> navBarItemList = [];
    for (var i = 0; i < iconList.length; i++) {
      navBarItemList.add(buildNavBarItem(iconList[i], i));
    }

    return Container(
        decoration: BoxDecoration(
          color: UiUtils.getColorScheme(context).secondary,
          borderRadius: const BorderRadius.only(topLeft: Radius.circular(10.0), topRight: Radius.circular(10.0)),
          boxShadow: [
            BoxShadow(blurRadius: 6, offset: const Offset(5.0, 5.0), color: darkBackgroundColor.withOpacity(0.4), spreadRadius: 0),
          ],
        ),
        child: ClipRRect(
            borderRadius: const BorderRadius.only(topLeft: Radius.circular(10.0), topRight: Radius.circular(10.0)),
            child: Row(
              children: navBarItemList,
            )
        )
    );
  }

  Widget content(){

    return Scaffold(
      appBar:  const CustomAppBar(title: "Conditions Générales",),
      body: SingleChildScrollView(
        physics: ClampingScrollPhysics(),
        child: Column(
          children: [
             const SizedBox(height: 20,),
             Padding(
              padding:  const EdgeInsets.only(left: 20.0, right: 20),
              child:  buildText(
                title: "Préambule",
                subText: """
                L’application ANKATA (ci-après « l’Application » est un service proposé par la SARL ANKATA TECHNOLOGIES dont le siège social est situé à Ouagadougou, 01 BP 1477.
                """
              ),
            ),
             Padding(
              padding:  const EdgeInsets.only(left: 20.0, right: 20),
              child:  buildText(
                title: "1. Objet",
                subText: """
                  Les présentes Conditions Générales d’Utilisation (ci-après « CGU » régissent l’utilisation de l’application mobile et l’utilisation des services proposés par ANKATA. L’utilisation de l’Application vaut acceptation sans réserve des présentes CGV.
                  """
              ),
            ),
             Padding(
              padding:  const EdgeInsets.only(left: 20.0, right: 20),
              child:  buildText(
                title: "2. Accès à l’Application et aux services fournis",
                subText: """
                ANKATA est une plateforme d’achat et de réservation de billets de transport routier de voyageurs par autocars. Les services proposés sont exclusivement accessibles par le biais d’un terminal androïde. L’utilisation de l’Application implique le consentement tacite de l’Utilisateur à la création automatisée d’un compte client. L’achat de billet sur l’Application se fait exclusivement via des services de paiement externes (type mobile money). Ces services externes communiquant la validité du paiement par message, l’Utilisateur se verra demander, par l’Application, l’autorisation de la lecture dudit message, à des fins de vérification de la validité du paiement.                
                Seuls les messages entrant issus de ces services de paiement peuvent être soumis à traitement. L’accès à l’Application est disponible 24 heures sur 24, 7 jours sur 7. Cependant, des problèmes techniques indépendants de notre volonté peuvent entraîner des périodes d’indisponibilité de l’Application.                
                Par ailleurs, des mesures de maintenance peuvent nuire à la disponibilité de l’Application. Celles-ci seront, dans la mesure du possible, réalisées de manière à limiter les désagréments occasionnés.
                """
              ),
            ),
             Padding(
              padding:  const EdgeInsets.only(left: 20.0, right: 20),
              child:  buildText(
                title: "3. Propriété intellectuelle",
                subText: """Cette Application est la propriété d’ANKATA TECHNOLOGIES SARL, elle constitue une œuvre protégée au titre de la propriété intellectuelle.
ANKATA TECHNOLOGIES dispose des autorisations nécessaires pour diffuser l’intégralité du contenu l’Application ou rendu disponible à travers l’Application et notamment, les textes, dessins, graphiques, images, photos, marques et logos... Ces contenus sont protégés par des droits de propriété intellectuelle.
Sauf autorisation écrite préalable d’ANKATA TECHNOLOGIES, l’Application et les informations qui y figurent ne peuvent être copiés, reproduits, modifiés, transmis, publiés sur quelques supports que ce soit, ni exploités en tout ou partie à des fins commerciales ou non commerciales, ni servir à la réalisation d’œuvres dérivées.
                """
              ),
            ),
             Padding(
              padding:  const EdgeInsets.only(left: 20.0, right: 20),
              child:  buildText(
                title: "4. Données personnelles",
                subText: """Les informations et données concernant les Utilisateurs sont traitées par ANKATA TECHNOLOGIES, elles sont nécessaires à la gestion de l’accès aux services et à la gestion des réservations.
Ces informations sont également traitées de façon anonyme à des fins de statistique et ne sont pas utilisées à d’autres fins commerciales.
Les informations nécessaires à la réservation de place et à l’achat de billets seront transférées à l’agence exécutrice du trajet aux seules fin d’assurer une identification nécessaire à l’accès au moyen de transport.
La consultation et la suppression de l’ensemble des données recueillies est possible par une simple demande par email.
                """
              ),
            ),
             Padding(
              padding:  const EdgeInsets.only(left: 20.0, right: 20),
              child:  buildText(
                title: "5. Responsabilité",
                subText: """La responsabilité d’ANKATA TECHNOLOGIES envers l’Utilisateur ne peut être engagée que pour des faits qui lui seraient directement imputables et qui lui causeraient un préjudice directement lié à ces faits. Elle ne peut être engagée pour les préjudices indirects.
La responsabilité d’ANKATA TECHNOLOGIES ne peut non plus être engagée du fait de la mauvaise utilisation des services par l’Utilisateur ou de toute faute de sa part. Elle ne saurait pas plus être engagée à raison de faits imputables à un tiers aux services.
L’Utilisateur est seul responsable de l’emploi qu'il fait du service fourni sur l’Application, notamment des appréciations qu'il fait sur l’Application, et s'engage à garantir à première demande à indemniser et dédommager ANKATA de tout dommage, perte, manque à gagner, que ANKATA pourrait subir si sa responsabilité se trouvait engagée par un tiers, du fait d'une action liée à cette utilisation de l’Application par l’Utilisateur.
"""
              ),
            ),
             Padding(
              padding:  const EdgeInsets.only(left: 20.0, right: 20),
              child:  buildText(
                title: "6. Nullité partielle",
                subText: """Si une ou plusieurs stipulations des présentes CGU sont tenues pour non valides ou déclarées comme tel en application d'une loi, d'un règlement ou d'une décision définitive d'une juridiction compétente, les autres stipulations garderont toute leur force et toute leur portée.
                """
              ),
            ),
             Padding(
              padding:  const EdgeInsets.only(left: 20.0, right: 20),
              child:  buildText(
                title: "7. Mise à jour",
                subText: """Les présentes Conditions Générales d’Utilisation sont conclues pour une durée indéterminée.
Nous pouvons être amenés à modifier les contenus et informations inclus dans cette Application ainsi que les présentes CGU, notamment afin de respecter toute nouvelle législation et/ou réglementation applicable et/ou afin d’améliorer l’Application.
Toute modification sera portée à la connaissance des Utilisateurs avant sa prise d’effet dans le cadre des présentes CGU. Sauf si la modification implique l’acceptation expresse de l’Utilisateur, le fait d’utiliser l’Application implique acceptation expresse des nouvelles Conditions d’Utilisation.
                """
              ),
            ),
             Padding(
              padding:  const EdgeInsets.only(left: 20.0, right: 20),
              child:  buildText(
                title: "8. Droit applicable et juridiction applicable",
                subText: """L’Application et les présentes CGU sont soumises au droit burkinabé.
Tout litige relatif à l’interprétation et/ou à l’exécution des CGU relève de la compétence des juridictions burkinabé en cas d’échec d’un règlement à l’amiable entre les Parties.                """
              ),
            ),
            const SizedBox(height: 20,),
          ],
        ),
      ),
    );
  }

  Column buildText({required String title, required String subText}) {
    return Column(
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w700
                  ),
                ),
                const SizedBox(height: 10,),
                Text(
                  subText,
                  textAlign: TextAlign.justify,
                  style: const TextStyle(
                    color: Colors.black,
                  ),
                ),
              ],
            );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          content(),
          //Add only if Category Mode is enabled From Admin panel.
          const TicketsScreen(),
          const ProfileScreen(),
        ],
      ),
      bottomNavigationBar: bottomBar(),
    );
  }
}
