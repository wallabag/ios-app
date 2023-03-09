#if os(iOS)
import CoreData
import Factory
import Foundation
import SharedLib
import UIKit

#if DEBUG
    // swiftlint:disable line_length
    extension AppDelegate {
        func populateApplication() {
            resetApplication()

            let appState = Container.shared.appState()
            appState.registred = true
            WallabagUserDefaults.defaultMode = "allArticles"
            WallabagUserDefaults.badgeEnabled = false

            let context = Container.shared.coreData().viewContext

            let entry = Entry(context: context)
            entry.title = "Marc Zuckerberg devrait être passible d'une peine de prison pour mensonges répétés au sujet de la protection de la vie privée des utilisateurs Facebook, d'après le sénateur américain Ron Wyden"
            entry.url = "https://www.developpez.com/actu/275880/Marc-Zuckerberg-devrait-etre-passible-d-une-peine-de-prison-pour-mensonges-repetes-au-sujet-de-la-protection-de-la-vie-privee-des-utilisateurs-Facebook-d-apres-le-senateur-americain-Ron-Wyden/"
            entry.previewPicture = "https://www.developpez.com/images/logos/mark-zuckerberg.png"
            entry.content = """
                    <img src="https://www.developpez.com/images/logos/mark-zuckerberg.png" class="c13" referrerpolicy="no-referrer" alt="image" /> La société Facebook est depuis quelque temps très critiquée sur la manière avec laquelle elle manipule les données de ses utilisateurs et les nombreux scandales comme celui de cambridge analytica, n’améliorent pas l’image de l’entreprise. D’ailleurs, après l'épisode de Cambridge Analytica, la société a reconnu plusieurs autres cas de manquements à la vie privée, dont celui d'admettre qu'elle avait mal géré les mots de passe d'utilisateurs sur Instagram. Bien que l’entreprise Facebook soit déjà sous le coup d’une <a href="https://www.developpez.com/actu/271222/La-FTC-inflige-une-amende-de-5-milliards-de-dollars-a-Facebook-et-apporte-des-clauses-qui-reduisent-considerablement-le-pouvoir-de-Mark-Zuckerberg/" target="_blank">amende de 5 milliards de dollars</a>, cela semble ne pas être suffisant pour certains qui estiment que les dirigeants devraient eux aussi être poursuivis en justice.
                    <p>En effet, un projet de loi présenté en 2018 par le sénateur Ron Wyden, donne à la FTC le pouvoir de sévir plus sévèrement contre les entreprises qui violent la vie privée des consommateurs. Selon le projet de loi, les dirigeants pourraient être condamnés à 20 ans de prison et à une amende de 5 millions de dollars. Et c’est dans ce sens que le sénateur Ron Wyden s’est exprimé lors d’une récente Interview qui portait sur l'article 230 de ce projet de loi, sur l'impact de cette législation et sur les conséquences néfastes, notamment le fait que Facebook utilisait cette législation à son avantage.</p><p>Au cours de cette interview, il a déclaré : « Mark Zuckerberg a menti à plusieurs reprises au peuple américain au sujet de la vie privée. Je pense qu'il devrait être tenu personnellement pour responsable, ce qui devrait entraîner des amendes financières et laissez-moi souligner également la possibilité d'une peine de prison parce qu'il a blessé beaucoup de gens ». Wyden a aussi mentionné le fait qu’il existait un précédent dans ce genre de cas : dans les services financiers, si le PDG et les dirigeants mentent au sujet des données financières, ils peuvent être tenus personnellement pour responsables.</p>
                    <div class="c14"><img src="https://www.developpez.net/forums/attachments/p501331d1/a/a/a" referrerpolicy="no-referrer" alt="image" /></div>
                    <br />Wyden n'est pas le premier législateur à proposer d'envoyer des cadres d’entreprises en prison. La sénatrice du Massachusetts, Elizabeth Warren, une candidate à la présidence de 2020 a dévoilé au début de cette année la loi sur la responsabilité des dirigeants d'entreprise, qui étend la responsabilité pénale aux dirigeants de toute société générant un chiffre d'affaires annuel supérieur à 1 milliard de dollars si cette société était reconnue coupable d'un crime ou d'une autre infraction civile. Malgré les souhaits de Wyden de voir Zuckerberg finir en prison, cela ne se produira probablement pas. C’est l’avis de Tim Gleason, un professeur de l’Université de l’Oregon, qui estime que les chances de Zuckerberg de faire face à une action criminelle sont plutôt minces.
                    <p>Pendant ce temps, plusieurs personnes pensent qu’emprisonner Zuckerberg ne réglera pas le problème, car il sera juste remplacé par quelqu'un d'autre qui fera pareil que lui. Ces personnes estiment qu’il serait peut-être plus judicieux de lui imposer une très grosse amende, qui servira à financer des œuvres sociales. Pour ces personnes, il est inutile de combattre ces milliardaires de cette façon, il faudrait plutôt utiliser leur cupidité contre eux.</p>
                    <p>Source : <a href="https://www.wweek.com/news/2019/08/28/ron-wyden-doesnt-apologize-for-helping-build-the-internet-but-hes-interested-in-sending-mark-zuckerberg-to-prison/" target="_blank">Willamette Week</a></p>
                    <p><strong>Et vous ?</strong></p>
                    <p><img src="https://www.developpez.net/forums/images/smilies/fleche.gif" border="0" alt="" title=":fleche:" class="inlineimg" referrerpolicy="no-referrer" /> Qu’en pensez-vous ?<br /><img src="https://www.developpez.net/forums/images/smilies/fleche.gif" border="0" alt="" title=":fleche:" class="inlineimg" referrerpolicy="no-referrer" /> Pensez-vous que Zuckerberg sera finalement inquiété ?<br /><img src="https://www.developpez.net/forums/images/smilies/fleche.gif" border="0" alt="" title=":fleche:" class="inlineimg" referrerpolicy="no-referrer" /> Quelles mesures proposeriez-vous pour contraindre les entreprises à respecter la vie privée des utilisateurs ?</p>
                    <p><strong>Voir aussi :</strong></p>
                    <p><img src="https://www.developpez.net/forums/images/smilies/fleche.gif" border="0" alt="" title=":fleche:" class="inlineimg" referrerpolicy="no-referrer" /><a href="https://www.developpez.com/actu/256658/Les-actionnaires-de-Facebook-en-ont-assez-de-Marc-Zuckerberg-mais-ne-peuvent-rien-faire-contre-lui-en-voici-les-raisons/" target="_blank">Les actionnaires de Facebook en ont assez de Marc Zuckerberg, mais ne peuvent rien faire contre lui, En voici les raisons</a><br /><img src="https://www.developpez.net/forums/images/smilies/fleche.gif" border="0" alt="" title=":fleche:" class="inlineimg" referrerpolicy="no-referrer" /><a href="https://www.developpez.com/actu/258769/Mark-Zuckerberg-ainsi-que-d-autres-cadres-dirigeants-de-Facebook-sont-poursuivis-en-justice-pour-les-scandales-lies-a-la-vie-privee/" target="_blank">Mark Zuckerberg ainsi que d'autres cadres dirigeants de Facebook sont poursuivis en justice Pour les scandales liés à la vie privée</a><br /><img src="https://www.developpez.net/forums/images/smilies/fleche.gif" border="0" alt="" title=":fleche:" class="inlineimg" referrerpolicy="no-referrer" /><a href="https://www.developpez.com/actu/224572/Mark-Zuckerberg-devrait-vendre-jusqu-a-13-Md-d-actions-Facebook-d-ici-mars-2019-pour-financer-les-actions-philanthropiques-de-sa-fondation-CZI/" target="_blank">Mark Zuckerberg devrait vendre jusqu'à 13 Md$ d'actions Facebook d'ici mars 2019 Pour financer les actions philanthropiques de sa fondation CZI</a></p>
            """
        }

        private func resetApplication() {
            do {
                // MARK: CoreData

                let context = Container.shared.coreData().viewContext
                let operations = NSBatchDeleteRequest(fetchRequest: Entry.fetchRequest())
                try context.execute(operations)

                let accounts = NSBatchDeleteRequest(fetchRequest: Tag.fetchRequest())
                try context.execute(accounts)

                try context.save()
            } catch {
                print("error resetting app")
            }
        }
    }
#endif

#endif
