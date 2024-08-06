import 'package:flutter/foundation.dart';

class HoroscopeProvider with ChangeNotifier {
  String _zodiacSign = '';
  String _horoscope = '';

  String get zodiacSign => _zodiacSign;
  String get horoscope => _horoscope;

  // Función para convertir la fecha de nacimiento en un signo zodiacal
  String _getZodiacSign(DateTime birthDate) {
    final int day = birthDate.day;
    final int month = birthDate.month;

    if ((month == 1 && day >= 20) || (month == 2 && day <= 18))
      return 'Acuario';
    if ((month == 2 && day >= 19) || (month == 3 && day <= 20)) return 'Piscis';
    if ((month == 3 && day >= 21) || (month == 4 && day <= 19)) return 'Aries';
    if ((month == 4 && day >= 20) || (month == 5 && day <= 20)) return 'Tauro';
    if ((month == 5 && day >= 21) || (month == 6 && day <= 20))
      return 'Géminis';
    if ((month == 6 && day >= 21) || (month == 7 && day <= 22)) return 'Cáncer';
    if ((month == 7 && day >= 23) || (month == 8 && day <= 22)) return 'Leo';
    if ((month == 8 && day >= 23) || (month == 9 && day <= 22)) return 'Virgo';
    if ((month == 9 && day >= 23) || (month == 10 && day <= 22)) return 'Libra';
    if ((month == 10 && day >= 23) || (month == 11 && day <= 21))
      return 'Escorpio';
    if ((month == 11 && day >= 22) || (month == 12 && day <= 21))
      return 'Sagitario';
    if ((month == 12 && day >= 22) || (month == 1 && day <= 19))
      return 'Capricornio';

    return 'Desconocido'; // Caso por defecto
  }

  // Función para obtener el horóscopo basado en el signo zodiacal
  String _getHoroscope(String sign) {
    // Datos simulados para los horóscopos
    Map<String, String> horoscopes = {
      'Acuario':
          'Lo que más necesitas en estos momentos, Acuario, es relajarte y tomarte un tiempo libre para poder librarte de la ansiedad y el estrés que te agobian a diario. Hoy toma medias para solucionarlo, es urgente. También tu afán por hacerlo todo deprisa. Acuario, Leo, te puede llevar a tomar decisiones equivocadas. Hoy mismo este tema te puede pasar factura porque a causa de las prisas podrías cometer un error. Tendrías que empezar a serenarte y delegar algunas de tus tareas en otras personas. Necesitas trabajar con tranquilidad a diario y sin excusas. . En el ámbito sentimental, Acuario, no estés preocupada por tu relación. El amor va cambiando, con el paso del tiempo atraviesa diferentes etapas, pero lo único importante es que los sentimientos sigan intactos a diario y que se mantenga la pasión. En tu caso todo marcha sobre ruedas y hay amor para rato.',
      'Piscis':
          'Hoy podría llegar la ocasión que esperabas a diario desde hace tiempo, Piscis. Quizá te elijan para liderar un equipo o para hablar en una presentación. Lo has deseado mucho pero ahora, ante la posibilidad real, el nerviosismo te está dominando sin motivo alguno. Muestra más seguridad, lo harás bien, tienes la capacidad y el talento necesarios para que todo salga redondo. Sólo necesitas echarle algo de valor y buscar apoyo entre quienes te quieren, aunque tú no correspondas  en la misma medida. Tienes la suerte de estar rodeada por amigos verdaderos que harían por ti lo que fuera. Préstales más atención a diario y convéncete de que su amistad es un gran  tesoro. También deberías dedicar algún tiempo a diario a la familia. Si no puedes visitarles, un mensaje  será suficiente, aunque hoy te iría muy  bien verles porque te dirán algo de gran  interés para ti.',
      'Aries':
          'Si ya te has reincorporado al trabajo, Aries, y te pesa lo tuyo a diario, hoy de sentirás más que contenta de haber vuelto porque quizá te ofrezcan un nuevo empleo o un buen trato comercial, algo que habría caído en otras manos de estar tú ausente. Confía en tu gran habilidad para detectar las oportunidades y también en tu intuición para saber cuál es el mejor enfoque para tratar el tema. En el terreno sentimental, Aries, llevas algún tiempo saliendo con alguien y cada vez te sientes más enamorada. No te conviene ser demasiado expresiva. No te excedas a diario con demostraciones de amor o efusividades, entre otras cosas porque tú chico quizá no sea muy amante de estas demostraciones de amor en público y además porque puede temer comprometerse demasiado. Ten hoy un poco de calma y disfruta de estos inicios tan prometedores.',
      'Tauro':
          'Confiesa hoy, Tauro, que llevas una  racha, en la que sólo piensas en  el trabajo. Has estado sacrificando a diario tiempo de estar con los amigos y quién sabe si no has sacrificado parte de tus vacaciones para poder seguir estando al pie del cañón. También llevas tiempo esquivando el amor por el mismo motivo. Crees que primero has  de alcanzar una estabilidad. Mientras, las  oportunidades  de encontrar la persona adecuada  van pasando sin que las detectes. Estás en un  error, Tauro, el amor te pondría más fáciles las cosas. La sensación de estar en paz con la vida que se tiene cuando estás enamorada, te ayudaría en todo lo demás. El verdadero amor, Tauro, siempre es positivo y compatible a diario con el trabajo, los estudios y cualquier otra obligación. Abre hoy tu puerta al amor porque hay alguien deseando entrar por ella.',
      'Géminis':
          'Necesitas hacer un  parón de tus múltiples actividades, versátil Géminis. Te has extralimitado asumiendo responsabilidades y lo que has conseguido es pillar un  estrés descomunal para poder cumplir con todo a diario. Lo estás consiguiendo, pero a un precio demasiado alto. No te das cuenta de ello pero cada día tienes molestias que no sabes a qué achacar. No dejes a nadie en la estacada pero advierte a quienes puedan verse afectados, que no podrás seguir con este ritmo. Ahora lo más importante es que puedas relajarte y descansar un  poco. Prioriza lo verdaderamente importante y aplaza lo demás. Todo esto te ha quitado también tiempo para estar  con la persona que te interesa. Si no le prestas más atención a diario no tardarás en detectar señales  de cansancio por su parte. Interésate hoy mismo por sus asuntos y recupera el tiempo perdido.',
      'Cáncer':
          'Hoy ya va siendo hora, Cáncer, de que abras los ojos y te des cuenta de que ese chico tan atento y simpático con quien te encuentras a diario en muchos lugares, te está tirando los trastos y que no es ninguna casualidad que esté siempre en todas partes. Si eres un corazón libre, deberías conocerle mejor porque si ahora ya te cae bien, más adelante podría caerte mejor. Sin embargo, si tienes ya pareja, será mejor afrontar la situación con sinceridad y dejarle claro que esta actitud  que tiene a diario podría causarte problemas con tu chico.  Hazlo hoy mismo, no esperes más. Quizá te encuentres también con un desliz de una amiga a quien le contaste un secreto sin advertírselo y ha metido la pata diciéndoselo a un tercero. No te enfades con ella, Cáncer, vuestra  amistad vale más  que el error que ha podido cometer.',
      'Leo':
          'Hoy, Leo, necesitas poner orden en tus cosas y muy especialmente en tu espacio de trabajo. Has notado que a diario te falta concentración o que vas más lenta de lo acostumbrado. Todo esto puede deberse a la energía negativa que se produce ante el acúmulo de cosas sin orden ni concierto. Libérate hoy de todo lo inservible y deja espacio para que entre la energía positiva. Si has pensado en pedir a alguien que te eche una mano en un tema que has de resolver, te resultará mejor intentar hacerlo antes por ti misma. En el terreno sentimental, si actualmente tienes el corazón libre,  Leo, en lugar de lamentarte por ello disfruta de las ventajas de esta situación, salir donde quieres y con quien te dé la gana a diario.  Haz hoy las cosas que te gustan y aprovecha para conocer gente de otros entornos.',
      'Virgo':
          'No puedes dejar pasar el día de hoy, Virgo, sin empezar a moverte para conseguir un empleo. Tienes grandes probabilidades de encontrar ese trabajo por el que estás suspirando a diario, pero no mueves un dedo. Ya va siendo hora de que decidas hacer algo más práctico que soñar con que va a llegar por arte de magia. En el terreno económico, hoy tendrás que enfrentarte a un gasto inesperado que puede desequilibrar tu economía si no has sido previsora. En el amor, la relación sentimental que mantienes en estos momentos te absorbe por completo, Virgo, y estás dejando de ver a tus amigos y a tu familia. Deberías repartir hoy mejor tu tiempo y buscar espacio para encontrarte con estas personas que te están echando de menos a diario. Además, una relación tan intensa puede provocar cansancio, en ti o en él.',
      'Libra':
          'Si estás ya trabajando, o esperando todavía tus vacaciones, Libra, no te mantengas hoy al margen de lo que ocurre en ese entorno. Participa en lo que surja y apóyate en tus compañeros de trabajo. Formas parte del equipo y te afecta todo lo que concierne a los hechos o las personas que están ahí contigo. Presta ayuda también cuando alguien lo necesite y no esperes a que te lo pidan, ofrécete a colaborar. Hoy te iría muy bien tener un ratito de charla con tus colegas, necesitas integrarles más en tu vida y estrechar lazos con ellos. También tus amigos podrían proponerte hoy un encuentro, Acepta porque conocerás gente muy interesante. En el amor, Libra, pon un toque de sorpresa y diversión en tu relación. Necesitáis romper la rutina y pasar tiempo a solas, os funcionará mejor.',
      'Escorpio':
          'Hoy es un día muy bien aspectado para sincerarse, Escorpio, para decir las verdades sin paños calientes. Algunas pueden llenar de satisfacción a quien las escuche, pero sin duda otras son incómodas. Aun así, si has de sincerarte con alguien es el momento de hacerlo, Escorpio, no encontrarás otro momento mejor. Tal vez estés necesitando a diario quitarte un peso de encima y ahora tienes la ocasión. También es un momento muy apropiado para poner ciertas cosas en claro con la pareja. No temas que se rebote, te entenderá y sacaréis conclusiones muy positivas. En otro orden de cosas, te gusta sentirte independiente y así lo vendes a diario a todo el mundo. Sin embargo, la comodidad te hace recurrir a otras personas a diario, incluso cuando no lo necesitas. Te sentirás mejor si actúas cono la persona autosuficiente que eres y de la que te gusta presumir.',
      'Sagitario':
          'Hay algo que no tienes, Sagitario, y que deseas con todas tus fuerzas. Esto te hace sentir insatisfecha a diario. Es una forma equivocada de plantearte el tema y no te ayudará a alcanzar lo que quieres. Si se trata de un asunto material o vinculado al trabajo, la mejor forma de intentar conseguirlo es teniendo paciencia y esforzándote para alcanzar tu objetivo. Sin embargo, si se trata de una persona de quien te sientes enamorada pero no te hace caso, la espera y la insatisfacción no te darán resultado. Tampoco te conviene esta forma de pensar ni de actuar. No estés tan pendiente a  diario de todos  sus  movimientos, sal con tus amigos, no le pongas en el centro de tu universo. Tu bienestar emocional no depende de esa persona especial, Sagitario. Quizá si le prestas menos atención conseguirás despertar su interés.',
      'Capricornio':
          'Te estás sintiendo a diario, Capricornio, inmersa en una rutina que te impide motivarte, también en el terreno sentimental. Lo que sucede es que la costumbre ha hecho que no aprecies lo suficiente lo que tienes a tu alrededor. Procura controlar esta forma de pensar negativa porque podría hacer mella realmente en tu relación sentimental. Cambia de actitud. Si quieres sentirte más realizada y más segura de ti misma, Capricornio, aprende a disfrutar con tus propios planes. Si aspiras poner un proyecto en marcha, lo puedes pasar en grande cuidando los detalles y explorando el mercado. No te desanimes si las cosas no suceden de inmediato, Capricornio, porque esto te hacer perder las ganas de luchar y las posibilidades de alcanzar tu objetivo. Si estás preparando un viaje, ten esto muy en cuenta. Disfrutarás más con los preparativos que con el viaje en sí mismo.'
    };

    return horoscopes[sign] ?? 'No hay horóscopo disponible.';
  }

  void setBirthDate(DateTime birthDate) {
    _zodiacSign = _getZodiacSign(birthDate);
    _horoscope = _getHoroscope(_zodiacSign);
    notifyListeners();
  }
}
