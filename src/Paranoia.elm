module Paranoia exposing (..)

import Browser
import Element exposing (..)
import Element.Font as Font
import Element.Input exposing (..)
import Element.Region exposing (description)
import Html exposing (Html)
import Html.Attributes exposing (style)
import Random
import String
import String.Interpolate exposing (interpolate)


type Msg
    = Instructions
    | Page1 Counters
    | Page2 Counters
    | Page3 Counters
    | Page4 Counters
    | Page5 Counters
    | Page6 Counters
    | Page7 Counters
    | Page8 Counters
    | Page9 Counters
    | Page10 Counters
    | Page10Tubecar Counters
    | Page10TubecarResult Counters (List Int)
    | Page11 Counters
    | Page11More Counters
    | Page12 Counters
    | Page13 Counters
    | Page14 Counters
    | Page15 Counters
    | Page16 Counters
    | Page17 Counters
    | Page17Fight Counters Int Int
    | Page17FightResult Counters Int Int Int Int Int (List Int)
    | Page18 Counters
    | Page18Balance Counters
    | Page18BalanceResult Counters (List Int)
    | Page19 Counters
    | Page19KilledTooMany Counters
    | Page20 Counters
    | Page21 Counters
    | Page22 Counters
    | Page22RandomEncounterResult Counters Int
    | Page23 Counters
    | Page24 Counters
    | Page25 Counters
    | Page26 Counters
    | Page28 Counters
    | Page29 Counters
    | Page30 Counters
    | Page31 Counters
    | Page32 Counters
    | Page33 Counters
    | Page34 Counters
    | Page34More Counters
    | Page35 Counters
    | Page36 Counters
    | Page37 Counters
    | Page38 Counters
    | Page39 Counters
    | Page40 Counters
    | Page40Fight Counters
    | Page40FightResult Counters Int Int
    | Page41 Counters
    | Page42 Counters
    | Page43 Counters
    | Page44 Counters
    | Page45 Counters
    | Page46 Counters
    | Page47 Counters
    | Page48 Counters
    | Page49 Counters
    | Page50 Counters
    | Page51 Counters
    | Page52 Counters
    | Page53 Counters
    | Page54 Counters
    | Page55 Counters
    | Page55More Counters
    | Page56 Counters
    | Page57 Counters
    | YouLose


type alias Counters =
    { moxie : Int
    , agility : Int
    , hitPoints : Int
    , clone : Int
    , killerCount : Int
    , maxKill : Int
    , platoClone : Int
    , computerRequest : Bool
    , ultraViolet : Bool
    , actionDoll : Bool
    , readLetter : Bool
    , blastDoor : Bool
    }


type alias Model =
    { description : String
    , next : List ( String, Msg )
    }


type alias DiceRolls =
    { r1 : Int
    , r2 : Int
    , r3 : Int
    , r4 : List Int
    }


type AttackResult
    = Dead
    | Injured Int
    | Missed


charsheet : Int -> String
charsheet clone =
    interpolate """
===============================================================================
The Character : Philo-R-DMD {0}
Primary Attributes                      Secondary Attributes
===============================================================================
Strength ..................... 13       Carrying Capacity ................. 30
Endurance .................... 13       Damage Bonus ....................... 0
Agility ...................... 15       Macho Bonus ....................... -1
Manual Dexterity ............. 15       Melee Bonus ...................... +5%%
Moxie ........................ 13       Aimed Weapon Bonus .............. +10%%
Chutzpah ...................... 8       Comprehension Bonus .............. +4%%
Mechanical Aptitude .......... 14       Believability Bonus .............. +5%%
Power Index .................. 10       Repair Bonus ..................... +5%%
===============================================================================
Credits: 160        Secret Society: Illuminati        Secret Society Rank: 1
Service Group: Power Services               Mutant Power: Precognition
Weapon: laser pistol to hit, 40%% type, L Range, 50m Reload, 6r Malfnt, 00
Skills: Basics 1(20%%), Aimed Weapon Combat 2(35%%), Laser 3(40%%),
        Personal Development 1(20%%), Communications 2(29%%), Intimidation 3(34%%)
Equipment: Red Reflec Armour, Laser Pistol, Laser Barrel (red),
           Notebook & Stylus, Knife, Com Unit 1, Jump suit,
           Secret Illuminati Eye-In-The-Pyramid(tm) Decoder ring,
           Utility Belt & Pouches
===============================================================================
""" [ String.fromInt clone ]


maybeNewClone : Counters -> Maybe Counters
maybeNewClone counters =
    if counters.clone > 6 then
        Nothing

    else
        Just
            { counters
                | clone = counters.clone + 1
                , ultraViolet = False
                , actionDoll = False
                , hitPoints = 10
                , killerCount = 0
            }


cloneDies : Counters -> Msg -> ( String, Msg )
cloneDies counters msg =
    ( interpolate "Clone {0} just died." [ String.fromInt counters.clone ], msg )


more : Msg -> ( String, Msg )
more msg =
    ( "More...", msg )


restart : ( String, Msg )
restart =
    ( "Restart", Page1 initCounters )


rollDice : Int -> Int -> Random.Generator (List Int)
rollDice num sides =
    Random.list num (Random.int 1 sides)


withCmdNone : Model -> ( Model, Cmd Msg )
withCmdNone model =
    ( model, Cmd.none )


instructionsModel : Model
instructionsModel =
    { description = """
Welcome to Paranoia!

HOW TO PLAY:
   Just press <Enter> until you are asked to make a choice.
   Type the number corresponding with your choice, then press <Enter>.
   You may select 'p' at any time to get a display of your statistics.
   You may select 'r' at any time to re-read the page.
   Always choose the least dangerous option.  Continue doing this until
   you win. At times you will use a skill or engage in combat and will
   be informed of the outcome.  These pages will be self explanatory.

HOW TO DIE:
   As Philo-R-DMD you will die at times during the adventure.
   When this happens you will be given a new clone at a particular
   location. The new Philo-R will usually have to retrace some of
   the old Philo-R's path, but hopefully he won't make the same mistake
   as his predecessor.

HOW TO WIN:
   Simply complete the mission before you expend all six clones.
   If you make it, congratulations.
   If not, you can try again later.
"""
    , next = [ more <| Page1 initCounters ]
    }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Instructions ->
            ( instructionsModel, Cmd.none )

        Page1 counters ->
            ( { description = """
You wake up face down on the red and pink checked E-Z-Kleen linoleum floor.
You recognise the pattern, it's the type preferred in the internal security
briefing cells.  When you finally look around you, you see that you are alone
in a large mission briefing room.
"""
              , next = [ more <| Page57 counters ]
              }
            , Cmd.none
            )

        Page2 counters ->
            let
                nextMsg =
                    case ( maybeNewClone counters, counters.computerRequest ) of
                        ( Nothing, _ ) ->
                            YouLose

                        ( Just newCloneCounters, True ) ->
                            Page45 newCloneCounters

                        ( Just newCloneCounters, False ) ->
                            Page32 newCloneCounters
            in
            ( { description = """
"Greetings," says the kindly Internal Security self incrimination expert who
meets you at the door, "How are we doing today?"  He offers you a doughnut
and coffee and asks what brings you here.  This doesn't seem so bad, so you
tell him that you have come to confess some possible security lapses.  He
smiles knowingly, deftly catching your coffee as you slump to the floor.
"Nothing to be alarmed about it's just the truth serum," he says,
dragging you back into a discussion room.
The next five hours are a dim haze, but you can recall snatches of conversation
about your secret society, your mutant power, and your somewhat paranoid
distrust of The Computer.  This should explain why you are hogtied and moving
slowly down the conveyer belt towards the meat processing unit in Food
Services.
"""
              , next = [ cloneDies counters nextMsg ]
              }
            , Cmd.none
            )

        Page3 counters ->
            ( { description = """
You walk to the nearest Computer terminal and request more information about
Christmas.  The Computer says, "That is an A-1 ULTRAVIOLET ONLY IMMEDIATE
TERMINATION classified topic.  What is your clearance please, Troubleshooter?"
"""
              , next =
                    [ ( "You give your correct clearance", Page4 counters )
                    , ( "You lie and claim Ultraviolet clearance", Page5 counters )
                    ]
              }
            , Cmd.none
            )

        Page4 counters ->
            ( { description = """
"That is classified information, Troubleshooter, thank you for your inquiry.
Please report to an Internal Security self incrimination station as soon as
possible."
"""
              , next = [ more <| Page9 counters ]
              }
            , Cmd.none
            )

        Page5 counters ->
            ( { description = """
The computer says, "Troubleshooter, you are not wearing the correct colour
uniform.  You must put on an Ultraviolet uniform immediately.  I have seen to
your needs and ordered one already it will be here shortly.  Please wait with
your back to the wall until it arrives."  In less than a minute an infrared
arrives carrying a white bundle.  He asks you to sign for it, then hands it to
you and stands back, well outside of a fragmentation grenade's blast radius.
"""
              , next =
                    [ ( "You open the package and put on the uniform", Page6 counters )
                    , ( "You finally come to your senses and run for it", Page7 counters )
                    ]
              }
            , Cmd.none
            )

        Page6 counters ->
            ( { description = """
The uniform definitely makes you look snappy and pert.  It really looks
impressive, and even has the new lopsided lapel fashion that you admire so
much.  What's more, citizens of all ranks come to obsequious attention as you
walk past.  This isn't so bad being an Ultraviolet.  You could probably come
to like it, given time.

The beeping computer terminal interrupts your musings.
"""
              , next =
                    [ more <| Page8 { counters | ultraViolet = True } ]
              }
            , Cmd.none
            )

        Page7 counters ->
            ( { description = """
The corridor lights dim and are replaced by red battle lamps as the Security
Breach alarms howl all around you.  You run headlong down the corridor and
desperately windmill around a corner, only to collide with a squad of 12 Blue
clearance Vulture squadron soldiers.  "Stop, Slime Face," shouts the
commander, "or there won't be enough of you left for a tissue sample."
"All right, soldiers, stuff the greasy traitor into the uniform," he orders,
waving the business end of his blue laser scant inches from your nose.
With his other hand he shakes open a white bundle to reveal a pristine new
Ultraviolet citizen's uniform.

One of the Vulture squadron Troubleshooters grabs you by the neck in the
exotic and very painful Vulture Clamp(tm) death grip (you saw a special about
it on the Teela O'Malley show), while the rest tear off your clothes and
force you into the Ultraviolet uniform.  The moment you are dressed they step
clear and stand at attention.
"Thank you for your cooperation, sir," says the steely eyed leader of the
Vulture Squad.  "We will be going about our business now."  With perfect
timing the Vultures wheel smartly and goosestep down the corridor.

Special Note: don't make the mistake of assuming that your skills have
improved any because of the uniform you're only a Red Troubleshooter
traitorously posing as an Ultraviolet, and don't you forget it!

Suddenly, a computer terminal comes to life beside you.
"""
              , next =
                    [ more <| Page8 { counters | ultraViolet = True } ]
              }
            , Cmd.none
            )

        Page8 counters ->
            ( { description = """
"Now, about your question, citizen.  Christmas was an old world marketing ploy
to induce lower clearance citizens to purchase vast quantities of goods, thus
accumulation a large amount of credit under the control of a single class of
citizen known as Retailers.  The strategy used is to imply that all good
citizens give gifts during Christmas, thus if one wishes to be a valuable
member of society one must also give gifts during Christmas.  More valuable
gifts make one a more valuable member, and thus did the Retailers come to
control a disproportionate amount of the currency.  In this way Christmas
eventually caused the collapse of the old world.  Understandably, Christmas
has been declared a treasonable practice in Alpha Complex.
Thank you for your inquiry."

You continue on your way to GDH7-beta.
"""
              , next = [ more <| Page10 counters ]
              }
            , Cmd.none
            )

        Page9 counters ->
            ( { description = """
As you walk toward the tubecar that will take you to GDH7-beta, you pass one
of the bright blue and orange Internal Security self incrimination stations.
Inside, you can see an IS agent cheerfully greet an infrared citizen and then
lead him at gunpoint into one of the rubber lined discussion rooms.
"""
              , next =
                    [ ( "You decide to stop here and chat, as ordered by The Computer"
                      , Page2 { counters | computerRequest = True }
                      )
                    , ( "You just continue blithely on past"
                      , Page10 counters
                      )
                    ]
              }
            , Cmd.none
            )

        Page10 counters ->
            ( { description = """
You stroll briskly down the corridor, up a ladder, across an unrailed catwalk,
under a perilously swinging blast door in urgent need of repair, and into
tubecar grand central.  This is the bustling hub of Alpha Complex tubecar
transportation.  Before you spreads a spaghetti maze of magnalift tube tracks
and linear accelerators.  You bravely study the specially enhanced 3-D tube
route map you wouldn't be the first Troubleshooter to take a fast tube ride
to nowhere.
"""
              , next =
                    let
                        condtionalChoices =
                            if counters.ultraViolet then
                                [ ( "You decide to ask The Computer about Christmas using a nearby terminal"
                                  , Page3 counters
                                  )
                                ]

                            else
                                []
                    in
                    condtionalChoices
                        ++ [ ( "You think you have the route worked out, so you'll board a tube train"
                             , Page10Tubecar counters
                             )
                           ]
              }
            , Cmd.none
            )

        Page10Tubecar counters ->
            ( model
            , Random.generate (Page10TubecarResult counters) (rollDice 2 10)
            )

        Page10TubecarResult counters diceResult ->
            let
                success =
                    List.sum diceResult < counters.moxie

                successText =
                    if success then
                        "YES - you did it!"

                    else
                        "Uh oh!"

                descriptionTemplate =
                    """
You nervously select a tubecar and step aboard.

Let's see if you can roll under your moxie ({0}). You roll two d10 - a {1}. {2}
"""

                description =
                    interpolate
                        descriptionTemplate
                        [ String.fromInt counters.moxie
                        , String.join " and a " <| List.map String.fromInt diceResult
                        , successText
                        ]
            in
            ( { description = description
              , next =
                    if success then
                        [ ( "You just caught a purple line tubecar."
                          , Page13 counters
                          )
                        ]

                    else
                        [ ( "You just caught a brown line tubecar."
                          , Page48 counters
                          )
                        ]
              }
            , Cmd.none
            )

        Page11 counters ->
            ( { description = """
The printing on the folder says "Experimental Self Briefing."
You open it and begin to read the following:

Step 1: Compel the briefing subject to attend the briefing.
        Note: See Experimental Briefing Sub Form Indigo-WY-2,
        'Experimental Self Briefing Subject Acquisition Through The Use Of
        Neurotoxin Room Foggers.'

Step 2: Inform the briefing subject that the briefing has begun.
        ATTENTION: THE BRIEFING HAS BEGUN.

Step 3: Present the briefing material to the briefing subject.
        GREETINGS TROUBLESHOOTER.
        YOU HAVE BEEN SPECIALLY SELECTED TO SINGLEHANDEDLY
        WIPE OUT A DEN OF TRAITOROUS CHRISTMAS ACTIVITY.  YOUR MISSION IS TO
        GO TO GOODS DISTRIBUTION HALL 7-BETA AND ASSESS ANY CHRISTMAS ACTIVITY
        YOU FIND THERE.  YOU ARE TO INFILTRATE THESE CHRISTMAS CELEBRANTS,
        LOCATE THEIR RINGLEADER, AN UNKNOWN MASTER RETAILER, AND BRING HIM
        BACK FOR EXECUTION AND TRIAL.  THANK YOU.  THE COMPUTER IS YOUR FRIEND.

Step 4: Sign the briefing subject's briefing release form to indicate that
        the briefing subject has completed the briefing.
        ATTENTION: PLEASE SIGN YOUR BRIEFING RELEASE FORM.

Step 5: Terminate the briefing
        ATTENTION: THE BRIEFING IS TERMINATED.
"""
              , next = [ more <| Page11More counters ]
              }
            , Cmd.none
            )

        Page11More counters ->
            ( { description = """
You walk to the door and hold your signed briefing release form up to the
plexiglass window.  A guard scrutinises it for a moment and then slides back
the megabolts holding the door shut.  You are now free to continue the
mission.
"""
              , next =
                    [ ( "You wish to ask The Computer for more information about Christmas"
                      , Page3 counters
                      )
                    , ( "You have decided to go directly to Goods Distribution Hall 7-beta"
                      , Page10 counters
                      )
                    ]
              }
            , Cmd.none
            )

        Page12 counters ->
            ( { description = """
You walk up to the door and push the button labelled "push to exit."
Within seconds a surly looking guard shoves his face into the small plexiglass
window.  You can see his mouth forming words but you can't hear any of them.
You just stare at him blankly for a few moments until he points down to a
speaker on your side of the door.  When you put your ear to it you can barely
hear him say, "Let's see your briefing release form, bud.  You aren't
getting out of here without it."
"""
              , next =
                    [ ( "You sit down at the table and read the Orange packet"
                      , Page11 counters
                      )
                    , ( "You stare around the room some more"
                      , Page57 counters
                      )
                    ]
              }
            , Cmd.none
            )

        Page13 counters ->
            ( { description = """
You step into the shiny plasteel tubecar, wondering why the shape has always
reminded you of bullets.  The car shoots forward the instant your feet touch
the slippery gray floor, pinning you immobile against the back wall as the
tubecar careens toward GDH7-beta.  Your only solace is the knowledge that it
could be worse, much worse.

Before too long the car comes to a stop.  You can see signs for GDH7-beta
through the window.  With a little practice you discover that you can crawl
to the door and pull open the latch.
"""
              , next = [ more <| Page14 counters ]
              }
            , Cmd.none
            )

        Page14 counters ->
            ( { description = """
You manage to pull yourself out of the tubecar and look around.  Before you is
one of the most confusing things you have ever seen, a hallway that is
simultaneously both red and green clearance.  If this is the result of
Christmas then it's easy to see the evils inherent in its practice.
You are in the heart of a large goods distribution centre.  You can see all
about you evidence of traitorous secret society Christmas celebration rubber
faced robots whiz back and forth selling toys to holiday shoppers, simul-plast
wreaths hang from every light fixture, while ahead in the shadows is a citizen
wearing a huge red synthetic flower.
"""
              , next = [ more <| Page22 counters ]
              }
            , Cmd.none
            )

        Page15 counters ->
            ( { description = """
You are set upon by a runty robot with a queer looking face and two pointy
rubber ears poking from beneath a tattered cap.  "Hey mister," it says,
"you done all your last minute Christmas shopping?  I got some real neat junk
here.  You don't wanna miss the big day tomorrow, if you know what I mean."
The robot opens its bag to show you a pile of shoddy Troubleshooter dolls.  It
reaches in and pulls out one of them.  "Look, these Action Troubleshooter(tm)
dolls are the neatest thing.  This one's got moveable arms and when you
squeeze him, his little rifle squirts realistic looking napalm.  It's only
50 credits.  Oh yeah, Merry Christmas."
"""
              , next =
                    [ ( "You decide to buy the doll.", Page16 counters )
                    , ( "You shoot the robot.", Page17 counters )
                    , ( "You ignore the robot and keep searching the hall.", Page22 counters )
                    ]
              }
            , Cmd.none
            )

        Page16 counters ->
            ( { description = """
The doll is a good buy for fifty credits it will make a fine Christmas present
for one of your friends.  After the sale, the robot rolls away.  You can use
the doll later in combat.  It works just like a cone rifle firing napalm,
except that occasionally it will explode and blow the user to smithereens.
But don't let that stop you.
"""
              , next = [ more <| Page22 { counters | actionDoll = True } ]
              }
            , Cmd.none
            )

        Page17 counters ->
            ( { description = """
You whip out your laser and shoot the robot, but not before it squeezes the
toy at you.  The squeeze toy has the same effect as a cone rifle firing napalm,
and the elfbot's armour has no effect against your laser.
"""
              , next = [ ( "Fight!", Page17Fight counters 1 15 ) ]
              }
            , Cmd.none
            )

        Page17Fight counters round enemyHitPoints ->
            let
                rollsToMsg : DiceRolls -> Msg
                rollsToMsg dr =
                    Page17FightResult counters round enemyHitPoints dr.r1 dr.r2 dr.r3 dr.r4

                gen : Random.Generator DiceRolls
                gen =
                    Random.map4 DiceRolls (Random.int 1 100) (Random.int 1 10) (Random.int 1 100) (rollDice 2 10)
            in
            ( model
            , Random.generate rollsToMsg gen
            )

        Page17FightResult counters round enemyHitPoints playerHitRoll playerDamageRoll enemyHitRoll enemyDamageRolls ->
            let
                checkHit : Int -> Int -> Int -> Int -> AttackResult
                checkHit skill hitPoints hitRoll damageRoll =
                    if playerHitRoll <= skill then
                        let
                            newHitPoints =
                                hitPoints - damageRoll
                        in
                        if newHitPoints <= 0 then
                            Dead

                        else
                            Injured newHitPoints

                    else
                        Missed

                ( description1, newCounters ) =
                    case checkHit 25 counters.hitPoints playerHitRoll playerDamageRoll of
                        Dead ->
                            ( [ "You have been hit!" ], { counters | hitPoints = 0 } )

                        Injured newPlayerHitPoints ->
                            ( [ "You have been hit!" ], { counters | hitPoints = newPlayerHitPoints } )

                        Missed ->
                            ( [ "It missed you, but not by much!" ], counters )

                ( description2, nextMsg ) =
                    if newCounters.hitPoints == 0 then
                        ( [], cloneDies counters <| Page45 { counters | hitPoints = 0 } )

                    else
                        case checkHit 40 enemyHitPoints enemyHitRoll (List.sum enemyDamageRolls) of
                            Dead ->
                                let
                                    ( lineEnd, newerCounters ) =
                                        if newCounters.hitPoints < 10 then
                                            ( " after the GDH medbot has patched you up.", { newCounters | hitPoints = 10 } )

                                        else
                                            ( ".", newCounters )
                                in
                                ( [ "You zapped the little bastard!", "You wasted it! Good shooting!", "You will need more evidence, so you search GDH7-beta further" ++ lineEnd ]
                                , more <| Page22 newerCounters
                                )

                            Injured newEnemyHitPoints ->
                                ( [ "You zapped the little bastard!" ]
                                , more <| Page17Fight newCounters (round + 1) newEnemyHitPoints
                                )

                            Missed ->
                                ( [ "Damn! You missed!" ]
                                , more <| Page17Fight newCounters (round + 1) enemyHitPoints
                                )
            in
            ( { description = description1 ++ description2 |> String.join "\n"
              , next = [ nextMsg ]
              }
            , Cmd.none
            )

        Page18 counters ->
            ( { description = """
You walk to the centre of the hall, ogling like an infrared fresh from the
clone vats.  Towering before you is the most unearthly thing you have ever
seen, a green multi armed mutant horror hulking 15 feet above your head.
Its skeletal body is draped with hundreds of metallic strips (probably to
negate the effects of some insidious mutant power), and the entire hideous
creature is wrapped in a thousand blinking hazard lights.  It's times like
this when you wish you'd had some training for this job.  Luckily the
creature doesn't take notice of you but stands unmoving, as though waiting for
a summons from its dark lord, the Master Retailer.
"""
              , next = [ more <| Page18Balance counters ]
              }
            , Cmd.none
            )

        Page18Balance counters ->
            ( model
            , Random.generate (Page18BalanceResult counters) (rollDice 2 10)
            )

        Page18BalanceResult counters diceResult ->
            let
                success =
                    List.sum diceResult < counters.agility

                successText =
                    if success then
                        "YES - you did it!"

                    else
                        "Uh oh!"

                descriptionTemplate =
                    """
WHAM, suddenly you are struck from behind.

Let's see if you can roll under your agility ({0}). You roll two d10 - a {1}. {2}
"""

                description =
                    interpolate
                        descriptionTemplate
                        [ String.fromInt counters.agility
                        , String.join " and a " <| List.map String.fromInt diceResult
                        , successText
                        ]
            in
            ( { description = description
              , next =
                    if success then
                        [ more <| Page19 counters
                        ]

                    else
                        [ more <| Page20 counters
                        ]
              }
            , Cmd.none
            )

        Page19 counters ->
            let
                newCounters =
                    { counters | killerCount = counters.killerCount + 1 }

                next =
                    if newCounters.killerCount > counters.maxKill - counters.clone then
                        [ more <| Page19KilledTooMany newCounters ]

                    else if counters.readLetter then
                        [ more <| Page22 newCounters ]

                    else
                        [ ( "You search the body, keeping an eye open for Internal Security", Page34 counters )
                        , ( "You run away like the cowardly dog you are", Page22 counters )
                        ]
            in
            ( { description = """
Quickly you regain your balance, whirl and fire your laser into the Ultraviolet
citizen behind you.  For a moment your heart leaps to your throat, then you
realise that he is indeed dead and you will be the only one filing a report on
this incident.  Besides, he was participating in this traitorous Christmas
shopping, as is evident from the rain of shoddy toys falling all around you.

Another valorous deed done in the service of The Computer!
"""
              , next = next
              }
            , Cmd.none
            )

        Page19KilledTooMany counters ->
            let
                nextMsg =
                    case maybeNewClone counters of
                        Nothing ->
                            YouLose

                        Just newCloneCounters ->
                            Page45 newCloneCounters
            in
            ( { description = """
You have been wasting the leading citizens of Alpha Complex at a prodigious
rate.  This has not gone unnoticed by the Internal Security squad at GDH7-beta.
Suddenly, a net of laser beams spear out of the gloomy corners of the hall,
chopping you into teeny, weeny bite size pieces.
"""
              , next = [ cloneDies counters nextMsg ]
              }
            , Cmd.none
            )

        Page20 counters ->
            ( { description = """
Oh no! you can't keep your balance.  You're falling, falling head first into
the Christmas beast's gaping maw.  It's a valiant struggle you think you are
gone when its poisonous needles dig into your flesh, but with a heroic effort
you jerk a string of lights free and jam the live wires into the creature's
spine.  The Christmas beast topples to the ground and begins to burn, filling
the area with a thick acrid smoke.  It takes only a moment to compose yourself,
and then you are ready to continue your search for the Master Retailer.
"""
              , next = [ more <| Page22 counters ]
              }
            , Cmd.none
            )

        Page21 counters ->
            ( { description = """
Suddenly a large florescent sign pops up from the ground. It reads "SCENARIO
THIS WAY" and points off between two rows of caroling elfbots.
"""
              , next =
                    [ ( "Follow the sign", Page29 counters )
                    , ( "Ignore the sign", Page22 counters )
                    ]
              }
            , Cmd.none
            )

        Page22 counters ->
            ( model
            , Random.generate (Page22RandomEncounterResult counters) (Random.int 1 4)
            )

        Page22RandomEncounterResult counters diceResult ->
            let
                next =
                    case diceResult of
                        1 ->
                            Page18 counters

                        2 ->
                            Page15 counters

                        3 ->
                            Page21 counters

                        _ ->
                            Page29 counters
            in
            ( { description = """
You are searching Goods Distribution Hall 7-beta.
"""
              , next = [ more next ]
              }
            , Cmd.none
            )

        Page23 counters ->
            ( { description = """
You go to the nearest computer terminal and declare yourself a mutant.
"A mutant, he's a mutant," yells a previously unnoticed infrared who had
been looking over your shoulder.  You easily gun him down, but not before a
dozen more citizens take notice and aim their weapons at you.
"""
              , next =
                    [ ( "You tell them that it was really only a bad joke", Page28 counters )
                    , ( "You want to fight it out, one against twelve", Page24 counters )
                    ]
              }
            , Cmd.none
            )

        Page24 counters ->
            ( { description = """
Golly, I never expected someone to pick this.  I haven't even designed
the 12 citizens who are going to make a sponge out of you.  Tell you what,
I'll give you a second chance.
"""
              , next =
                    [ ( "You change your mind and say it was only a bad joke", Page28 counters )
                    , ( "You REALLY want to shoot it out", Page25 counters )
                    ]
              }
            , Cmd.none
            )

        Page25 counters ->
            ( { description = """
Boy, you really can't take a hint!
They're closing in.  Their trigger fingers are twitching, they're about to
shoot.  This is your last chance.
"""
              , next =
                    [ ( "You tell them it was all just a bad joke", Page28 counters )
                    , ( "You are going to shoot", Page26 counters )
                    ]
              }
            , Cmd.none
            )

        Page26 counters ->
            let
                nextMsg =
                    case maybeNewClone counters of
                        Nothing ->
                            YouLose

                        Just newCloneCounters ->
                            Page32 newCloneCounters
            in
            ( { description = """
You can read the cold, sober hatred in their eyes (They really didn't think
it was funny), as they tighten the circle around you.  One of them shoves a
blaster up your nose, but that doesn't hurt as much as the multi-gigawatt
carbonium tipped food drill in the small of your back.
You spend the remaining micro-seconds of your life wondering what you did wrong
"""
              , next = [ cloneDies counters nextMsg ]
              }
            , Cmd.none
            )

        Page28 counters ->
            ( { description = """
They don't think it's funny.
"""
              , next = [ more <| Page26 counters ]
              }
            , Cmd.none
            )

        Page29 counters ->
            ( { description = """
"Psst, hey citizen, come here.  Pssfft," you hear.  When you peer around
you can see someone's dim outline in the shadows.  "I got some information
on the Master Retailer.  It'll only cost you 30 psst credits."
"""
              , next =
                    [ ( "You pay the 30 credits for the info.", Page30 counters )
                    , ( "You would rather threaten him for the information.", Page31 counters )
                    , ( "You ignore him and walk away.", Page22 counters )
                    ]
              }
            , Cmd.none
            )

        Page30 counters ->
            ( { description = """
You step into the shadows and offer the man a thirty credit bill.  "Just drop
it on the floor," he says.  "So you're looking for the Master Retailer, pssfft?
I've seen him, he's a fat man in a fuzzy red and white jump suit.  They say
he's a high programmer with no respect for proper security.  If you want to
find him then pssfft step behind me and go through the door."
Behind the man is a reinforced plasteel blast door.  The centre of it has been
buckled toward you in a manner you only saw once before when you were field
testing the rocket assist plasma slingshot (you found it easily portable but
prone to misfire).  Luckily it isn't buckled too far for you to make out the
warning sign.  WARNING!! Don't open this door or the same thing will happen to
you.  Opening this door is a capital offense.  Do not do it.  Not at all. This
is not a joke.
"""
              , next =
                    [ ( "You use your Precognition mutant power on opening the door.", Page56 counters )
                    , ( "You just go through the door anyway.", Page33 counters )
                    , ( "You decide it's too dangerous and walk away.", Page22 counters )
                    ]
              }
            , Cmd.none
            )

        Page31 counters ->
            ( { description = """
Like any good troubleshooter you make the least expensive decision and threaten
him for information.  With lightning like reflexes you whip out your laser and
stick it up his nose.  "Talk, you traitorous Christmas celebrator, or who nose
what will happen to you, yuk yuk," you pun menacingly, and then you notice
something is very wrong.  He doesn't have a nose.  As a matter of fact he's
made of one eighth inch cardboard and your laser is sticking through the other
side of his head.  "Are you going to pay?" says his mouth speaker,
"or are you going to pssfft go away stupid?"
"""
              , next =
                    [ ( "You pay the 30 credits", Page30 counters )
                    , ( "You pssfft go away stupid", Page22 counters )
                    ]
              }
            , Cmd.none
            )

        Page32 counters ->
            ( { description = """
Finally it's your big chance to prove that you're as good a troubleshooter
as your previous clone.  You walk briskly to mission briefing and pick up your
previous clone's personal effects and notepad.  After reviewing the notes you
know what has to be done.  You catch the purple line to Goods Distribution Hall
7-beta and begin to search for the blast door.
"""
              , next = [ more <| Page22 counters ]
              }
            , Cmd.none
            )

        Page33 counters ->
            ( { description = """
You release the megabolts on the blast door, then strain against it with your
awesome strength.  Slowly the door creaks open.  You bravely leap through the
opening and smack your head into the barrel of a 300 mm 'ultra shock' class
plasma cannon.  It's dark in the barrel now, but just before your head got
stuck you can remember seeing a group of technicians anxiously watch you leap
into the room.
"""
              , next =
                    let
                        newCounters =
                            { counters | blastDoor = True }
                    in
                    if counters.ultraViolet then
                        [ more <| Page35 newCounters ]

                    else
                        [ more <| Page36 newCounters ]
              }
            , Cmd.none
            )

        Page34 counters ->
            ( { description = """
You have found a sealed envelope on the body.  You open it and read:
"WARNING: Ultraviolet Clearance ONLY.  DO NOT READ.

Memo from Chico-U-MRX4 to Harpo-U-MRX5.

The planned takeover of the Troubleshooter Training Course goes well, Comrade.
Once we have trained the unwitting bourgeois troubleshooters to work as
communist dupes, the overthrow of Alpha Complex will be unstoppable.  My survey
of the complex has convinced me that no one suspects a thing soon it will be
too late for them to oppose the revolution.  The only thing that could possibly
impede the people's revolution would be someone alerting The Computer to our
plans (for instance, some enterprising Troubleshooter could tell The Computer
that the communists have liberated the Troubleshooter Training Course and plan
to use it as a jumping off point from which to undermine the stability of all
Alpha Complex), but as we both know, the capitalistic Troubleshooters would
never serve the interests of the proletariat above their own bourgeois desires.

P.S. I'm doing some Christmas shopping later today.  Would you like me to pick
you up something?"
"""
              , next = [ more <| Page34More counters ]
              }
            , Cmd.none
            )

        Page34More counters ->
            ( { description = """
When you put down the memo you are overcome by that strange deja'vu again.
You see yourself talking privately with The Computer.  You are telling it all
about the communists' plan, and then the scene shifts and you see yourself
showered with awards for foiling the insidious communist plot to take over the
complex.
"""
              , next =
                    let
                        newCounters =
                            { counters | readLetter = True }
                    in
                    [ ( "You rush off to the nearest computer terminal to expose the commies", Page46 newCounters )
                    , ( "You wander off to look for more evidence", Page22 newCounters )
                    ]
              }
            , Cmd.none
            )

        Page35 counters ->
            let
                nextMsg =
                    case maybeNewClone counters of
                        Nothing ->
                            YouLose

                        Just newCloneCounters ->
                            Page32 newCloneCounters
            in
            ( { description = """
"Oh master," you hear through the gun barrel, "where have you been? It is
time for the great Christmas gifting ceremony.  You had better hurry and get
the costume on or the trainee may begin to suspect."  For the second time
today you are forced to wear attire not of your own choosing.  They zip the
suit to your chin just as you hear gunfire erupt behind you.
"Oh no! Who left the door open?  The commies will get in.  Quick, fire the
laser cannon or we're all doomed."
"Too late you capitalist swine, the people's revolutionary strike force claims
this cannon for the proletariat's valiant struggle against oppression.  Take
that, you running dog imperialist lackey.  ZAP, KAPOW"
Just when you think that things couldn't get worse, "Aha, look what we have
here, the Master Retailer himself with his head caught in his own cannon.  His
death will serve as a symbol of freedom for all Alpha Complex.
Fire the cannon."
"""
              , next = [ cloneDies counters nextMsg ]
              }
            , Cmd.none
            )

        Page36 counters ->
            ( { description = """
"Congratulations, troubleshooter, you have successfully found the lair of the
Master Retailer and completed the Troubleshooter Training Course test mission,"
a muffled voice tells you through the barrel.  "Once we dislodge your head
from the barrel of the 'Ultra Shock' plasma cannon you can begin with the
training seminars, the first of which will concern the 100% accurate
identification and elimination of unregistered mutants.  If you have any
objections please voice them now."
"""
              , next =
                    [ ( "You appreciate his courtesy and voice an objection.", Page32 counters )
                    , ( "After your head is removed from the cannon, you register as a mutant.", Page23 counters )
                    , ( "After your head is removed from the cannon, you go to the unregistered mutant identification and elimination seminar.", Page37 counters )
                    ]
              }
            , Cmd.none
            )

        Page37 counters ->
            ( { description = """
"Come with me please, Troubleshooter," says the Green clearance technician
after he has dislodged your head from the cannon.  "You have been participating
in the Troubleshooter Training Course since you got off the tube car in
GDH7-beta," he explains as he leads you down a corridor.  "The entire
Christmas assignment was a test mission to assess your current level of
training.  You didn't do so well.  We're going to start at the beginning with
the other student.  Ah, here we are, the mutant identification and elimination
lecture."  He shows you into a vast lecture hall filled with empty seats.
There is only one other student here, a Troubleshooter near the front row
playing with his Action Troubleshooter(tm) figure.  "Find a seat and I will
begin," says the instructor.
"""
              , next = [ more <| Page38 counters ]
              }
            , Cmd.none
            )

        Page38 counters ->
            let
                description =
                    """
"I am Plato-B-PHI {0}, head of mutant propaganda here at the training
course.

If you have any questions about mutants please come to me.  Today I will be
talking about mutant detection.  Detecting mutants is very easy.  One simply
watches for certain tell tale signs, such as the green scaly skin, the third
arm growing from the forehead, or other similar disfigurements so common with
their kind.  There are, however, a few rare specimens that show no outward sign
of their treason.  This has been a significant problem, so our researchers have
been working on a solution.  I would like a volunteer to test this device,"
he says, holding up a ray gun looking thing.  "It is a mutant detection ray.
This little button detects for mutants, and this big button stuns them once
they are discovered.  Who would like to volunteer for a test?"

The Troubleshooter down the front squirms deeper into his chair.
"""
            in
            ( { description = interpolate description [ String.fromInt counters.platoClone ]
              , next =
                    [ ( "You volunteer for the test", Page39 counters )
                    , ( "You duck behind a chair and hope the instructor doesn't notice you", Page40 counters )
                    ]
              }
            , Cmd.none
            )

        Page39 counters ->
            let
                description =
                    """
You bravely volunteer to test the mutant detection gun.  You stand up and walk
down the steps to the podium, passing a very relieved Troubleshooter along the
way. When you reach the podium Plato-B-PHI {0} hands you the mutant detection gun
and says, "Here, aim the gun at that Troubleshooter and push the small button.
If you see a purple light, stun him."  Grasping the opportunity to prove your
worth to The Computer, you fire the mutant detection ray at the Troubleshooter.
A brilliant purple nimbus instantly surrounds his body.  You slip your finger
to the large stun button and he falls writhing to the floor.

"Good shot," says the instructor as you hand him the mutant detection gun,
"I'll see that you get a commendation for this.  It seems you have the hang
of mutant detection and elimination.  You can go on to the secret society
infiltration class.  I'll see that the little mutie gets packaged for
tomorrow's mutant dissection class."
"""
            in
            ( { description = interpolate description [ String.fromInt counters.platoClone ]
              , next = [ more <| Page41 counters ]
              }
            , Cmd.none
            )

        Page40 counters ->
            let
                description =
                    """
You breathe a sigh of relief as Plato-B-PHI {0} picks on the other Troubleshooter.
"You down here in the front," says the instructor pointing at the other
Troubleshooter, "you'll make a good volunteer.  Please step forward."
The Troubleshooter looks around with a 'who me?' expression on his face, but
since he is the only one visible in the audience he figures his number is up.
He walks down to the podium clutching his Action Troubleshooter(tm) doll before
him like a weapon.  "Here," says Plato-B-PHI {0}, "take the mutant detection ray
and point it at the audience.  If there are any mutants out there we'll know
soon enough."  Suddenly your skin prickles with static electricity as a bright
purple nimbus surrounds your body.  "Ha Ha, got one," says the instructor.

"Stun him before he gets away."
"""
            in
            ( { description = interpolate description [ String.fromInt counters.platoClone ]
              , next = [ ( "Fight!", Page40Fight counters ) ]
              }
            , Cmd.none
            )

        Page40Fight counters ->
            let
                gen : Random.Generator ( Int, Int )
                gen =
                    Random.pair (Random.int 1 100) (Random.int 1 100)
            in
            ( model
            , Random.generate (\( r1, r2 ) -> Page40FightResult counters r1 r2) gen
            )

        Page40FightResult counters playerHitRoll enemyHitRoll ->
            let
                ( description, nextMsg ) =
                    if playerHitRoll <= 30 then
                        ( "His shot hits you.  You feel numb all over.", more <| Page49 counters )

                    else if enemyHitRoll <= 40 then
                        ( "His shot just missed.\n\nYou just blew his head off.  His lifeless hand drops the mutant detector ray.", more <| Page50 counters )

                    else
                        ( "His shot just missed.\n\nYou burnt a hole in the podium.  He sights the mutant detector ray on you.", more <| Page40Fight counters )
            in
            ( { description = description
              , next = [ nextMsg ]
              }
            , Cmd.none
            )

        Page41 counters ->
            ( { description = """
You stumble down the hallway of the Troubleshooter Training Course looking for
your next class.  Up ahead you see one of the instructors waving to you.  When
you get there he shakes your hand and says, "I am Jung-I-PSY.  Welcome to the
secret society infiltration seminar.  I hope you ..."  You don't catch the
rest of his greeting because you're paying too much attention to his handshake
it is the strangest thing that has ever been done to your hand, sort of how it
would feel if you put a neuro whip in a high energy palm massage unit.

It doesn't take you long to learn what he is up to you feel him briefly shake
your hand with the secret Illuminati handshake.
"""
              , next =
                    [ ( "You respond with the proper Illuminati code phrase, \"Ewige Blumenkraft\"", Page42 counters )
                    , ( "You ignore this secret society contact", Page43 counters )
                    ]
              }
            , Cmd.none
            )

        Page42 counters ->
            ( { description = """
"Aha, so you are a member of the elitist Illuminati secret society," he says
loudly, "that is most interesting."  He turns to the large class already
seated in the auditorium and says, "You see, class, by simply using the correct
hand shake you can identify the member of any secret society.  Please keep your
weapons trained on him while I call a guard.
"""
              , next =
                    [ ( "You run for it", Page51 counters )
                    , ( "You wait for the guard", Page52 counters )
                    ]
              }
            , Cmd.none
            )

        Page43 counters ->
            ( { description = """
You sit through a long lecture on how to recognise and infiltrate secret
societies, with an emphasis on mimicking secret handshakes.  The basic theory,
which you realise to be sound from your Iluminati training, is that with the
proper handshake you can pass unnoticed in any secret society gathering.
What's more, the proper handshake will open doors faster than an 'ultra shock'
plasma cannon.  You are certain that with the information you learn here you
will easily be promoted to the next level of your Illuminati secret society.
The lecture continues for three hours, during which you have the opportunity
to practice many different handshakes.  Afterwards everyone is directed to
attend the graduation ceremony.  Before you must go you have a little time to
talk to The Computer about, you know, certain topics.
"""
              , next =
                    [ ( "You go looking for a computer terminal", Page44 counters )
                    , ( "You go to the graduation ceremony immediately", Page55 counters )
                    ]
              }
            , Cmd.none
            )

        Page44 counters ->
            ( { description = """
You walk down to a semi-secluded part of the training course complex and
activate a computer terminal.  "AT YOUR SERVICE" reads the computer screen.
"""
              , next =
                    if counters.readLetter then
                        [ ( "You register yourself as a mutant.", Page23 counters )
                        , ( "You want to chat about the commies.", Page46 counters )
                        , ( "You change your mind and go to the graduation ceremony.", Page55 counters )
                        ]

                    else
                        [ ( "You register yourself as a mutant.", Page23 counters )
                        , ( "You change your mind and go to the graduation ceremony.", Page55 counters )
                        ]
              }
            , Cmd.none
            )

        Page45 counters ->
            ( { description = """
"Hrank Hrank," snorts the alarm in your living quarters.  Something is up.
You look at the monitor above the bathroom mirror and see the message you have
been waiting for all these years.  "ATTENTION TROUBLESHOOTER, YOU ARE BEING
ACTIVATED. PLEASE REPORT IMMEDIATELY TO MISSION ASSIGNMENT ROOM A17/GAMMA/LB22.
THANK YOU. THE COMPUTER IS YOUR FRIEND."  When you arrive at mission
assignment room A17-gamma/LB22 you are given your previous clone's
remaining possessions and notebook.  You puzzle through your predecessor's
cryptic notes, managing to decipher enough to lead you to the tube station and
the tube car to GDH7-beta.
"""
              , next = [ more <| Page10 counters ]
              }
            , Cmd.none
            )

        Page46 counters ->
            ( { description = """
"Why do you ask about the communists, Troubleshooter?  It is not in the
interest of your continued survival to be asking about such topics," says
The Computer.
"""
              , next =
                    [ ( "You insist on talking about the communists", Page53 counters )
                    , ( "You change the subject", Page54 counters )
                    ]
              }
            , Cmd.none
            )

        Page47 counters ->
            ( { description = """
The Computer orders the entire Vulture squadron to terminate the Troubleshooter
Training Course.  Unfortunately you too are terminated for possessing
classified information.

Don't act so innocent, we both know that you are an Illuminatus which is in
itself an act of treason.

Don't look to me for sympathy.

\t\t\tTHE END
"""
              , next = [ restart ]
              }
            , Cmd.none
            )

        Page48 counters ->
            let
                nextMsg =
                    case maybeNewClone counters of
                        Nothing ->
                            YouLose

                        Just newCloneCounters ->
                            Page45 newCloneCounters
            in
            ( { description = """
The tubecar shoots forward as you enter, slamming you back into a pile of
garbage.  The front end rotates upward and you, the garbage and the garbage
disposal car shoot straight up out of Alpha Complex.  One of the last things
you see is a small blue sphere slowly dwindling behind you.  After you fail to
report in, you will be assumed dead.
"""
              , next = [ cloneDies counters nextMsg ]
              }
            , Cmd.none
            )

        Page49 counters ->
            let
                nextMsg =
                    case maybeNewClone counters of
                        Nothing ->
                            YouLose

                        Just newCloneCounters ->
                            Page32 newCloneCounters
            in
            ( { description = """
The instructor drags your inert body into a specimen detainment cage.
"He'll make a good subject for tomorrow's mutant dissection class," you hear.
"""
              , next = [ cloneDies counters nextMsg ]
              }
            , Cmd.none
            )

        Page50 counters ->
            ( { description = """
You put down the other Troubleshooter, and then wisely decide to drill a few
holes in the instructor as well the only good witness is a dead witness.
You continue with the training course.
"""
              , next = [ more <| Page41 { counters | platoClone = counters.platoClone + 1 } ]
              }
            , Cmd.none
            )

        Page51 counters ->
            let
                nextMsg =
                    case maybeNewClone counters of
                        Nothing ->
                            YouLose

                        Just newCloneCounters ->
                            Page32 newCloneCounters
            in
            ( { description = """
You run for it, but you don't run far.  Three hundred strange and exotic
weapons turn you into a freeze dried cloud of soot.
"""
              , next = [ cloneDies counters nextMsg ]
              }
            , Cmd.none
            )

        Page52 counters ->
            ( { description = """
You wisely wait until the instructor returns with a Blue Internal Security
guard.  The guard leads you to an Internal Security self incrimination station.
"""
              , next = [ more <| Page2 counters ]
              }
            , Cmd.none
            )

        Page53 counters ->
            ( { description = """
You tell The Computer about:
"""
              , next =
                    [ ( "The commies who have infiltrated the Troubleshooter Training Course and the impending People's Revolution", Page47 counters )
                    , ( "Something less dangerous", Page54 counters )
                    ]
              }
            , Cmd.none
            )

        Page54 counters ->
            let
                nextMsg =
                    case maybeNewClone counters of
                        Nothing ->
                            YouLose

                        Just newCloneCounters ->
                            if counters.blastDoor then
                                Page32 newCloneCounters

                            else
                                Page45 newCloneCounters
            in
            ( { description = """
"Do not try to change the subject, Troubleshooter," says The Computer.
"It is a serious crime to ask about the communists.  You will be terminated
immediately.  Thank you for your inquiry.  The Computer is your friend."
Steel bars drop to your left and right, trapping you here in the hallway.
A spotlight beams from the computer console to brilliantly iiluminate you while
the speaker above your head rapidly repeats "Traitor, Traitor, Traitor."
It doesn't take long for a few guards to notice your predicament and come to
finish you off.
"""
              , next = [ cloneDies counters nextMsg ]
              }
            , Cmd.none
            )

        Page55 counters ->
            ( { description = """
You and 300 other excited graduates are marched from the lecture hall and into
a large auditorium for the graduation exercise.  The auditorium is
extravagantly decorated in the colours of the graduating class.  Great red and
green plasti-paper ribbons drape from the walls, while a huge sign reading
"Congratulations class of GDH7-beta-203.44/A" hangs from the raised stage down
front.  Once everyone finds a seat the ceremony begins.  Jung-I-PSY is the
first to speak, "Congratulations students, you have successfully survived the
Troubleshooter Training Course.  It always brings me great pride to address
the graduating class, for I know, as I am sure you do too, that you are now
qualified for the most perilous missions The Computer may select for you.  The
thanks is not owed to us of the teaching staff, but to all of you, who have
persevered and graduated.  Good luck and die trying."  Then the instructor
begins reading the names of the students who one by one walk to the front of
the auditorium and receive their diplomas.
"""
              , next = [ more <| Page55More counters ]
              }
            , Cmd.none
            )

        Page55More counters ->
            let
                description =
                    """
Soon it is your turn, "Philo-R-DMD, graduating a master of mutant
identification and secret society infiltration."  You walk up and receive your
diploma from Plato-B-PHI {0}, then return to your seat.  There is another speech
after the diplomas are handed out, but it is cut short by by rapid
fire laser bursts from the high spirited graduating class.  You are free to
return to your barracks to wait, trained and fully qualified, for your next
mission.  You also get that cherished promotion from the Illuminati secret
society.  In a week you receive a detailed Training Course bill totalling
1,523 credits.

\t\t\tTHE END
"""
            in
            ( { description = interpolate description [ String.fromInt counters.platoClone ]
              , next = [ restart ]
              }
            , Cmd.none
            )

        Page56 counters ->
            ( { description = """
That familiar strange feeling of déjà vu envelops you again.  It is hard to
say, but whatever is on the other side of the door does not seem to be intended
for you.
"""
              , next =
                    [ ( "You open the door and step through", Page33 counters )
                    , ( "You go looking for more information", Page22 counters )
                    ]
              }
            , Cmd.none
            )

        Page57 counters ->
            ( { description = """
In the centre of the room is a table and a single chair.  There is an Orange
folder on the table top, but you can't make out the lettering on it.
"""
              , next =
                    [ ( "You sit down and read the folder", Page11 counters )
                    , ( "You leave the room", Page12 counters )
                    ]
              }
            , Cmd.none
            )

        YouLose ->
            ( { description = """
*** You Lose ***

All your clones are dead.  Your name has been stricken from the records.

THE END
"""
              , next = [ restart ]
              }
            , Cmd.none
            )


initCounters =
    { moxie = 13
    , agility = 15
    , hitPoints = 10
    , clone = 1
    , killerCount = 0
    , maxKill = 7
    , platoClone = 3
    , computerRequest = False
    , ultraViolet = False
    , actionDoll = False
    , readLetter = False
    , blastDoor = False
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( instructionsModel, Cmd.none )


main =
    Browser.element
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


preFormattedElement : String -> Element msg
preFormattedElement text =
    paragraph
        [ Font.family [ Font.monospace ]
        , Element.htmlAttribute (style "white-space" "pre")
        ]
        [ Element.html
            (Html.text text)
        ]


view : Model -> Html Msg
view model =
    Element.layout [] <|
        Element.textColumn [ spacingXY 10 30, padding 10 ] <|
            let
                descriptionPara =
                    paragraph []
                        [ preFormattedElement <| model.description ]

                otherParas =
                    List.map
                        (\( linkText, msg ) ->
                            paragraph []
                                [ button []
                                    { onPress = Just <| msg
                                    , label = Element.text linkText
                                    }
                                ]
                        )
                    <|
                        model.next
            in
            descriptionPara :: otherParas
