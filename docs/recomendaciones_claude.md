# Recomendaciones de desarrollo — Taller mecánico: fin del mundo

> Tower Defense · Low poly 3D · Godot 4 · GDScript

---

## 1. Diseñá en papel antes de tocar Godot

Antes de escribir una línea de código, definí con tu compañero:

- ¿Cuántos tipos de defensa hay en v1? (el GDD dice 3–4, dejalo fijo)
- ¿Cómo funciona exactamente el BuildSystem? ¿Grid fija, puntos de construcción, libre?
- ¿Qué hace el jefe que los zombies normales no hacen?

Un diagrama simple te evita reescribir sistemas enteros a mitad del proyecto.

---

## 2. Escenas pequeñas y reutilizables desde el día 1

La tentación es hacer una escena gigante con todo adentro. No lo hagas.

Cada zombie, cada defensa, cada proyectil debe ser su propia escena. Si después querés cambiar algo, lo cambiás en un solo lugar y se actualiza en todo el juego. Para este proyecto, la estructura mínima sería:

```
res://
├── scenes/
│   ├── enemies/       # zombie_basico.tscn, zombie_rapido.tscn, jefe.tscn
│   ├── towers/        # trampa.tscn, tuberia.tscn, motor.tscn
│   ├── ui/            # hud.tscn, menu_principal.tscn
│   └── levels/        # zona_ciudad_01.tscn
├── scripts/
│   ├── managers/      # GameManager.gd, WaveManager.gd
│   └── autoloads/     # GameState.gd
├── assets/
│   ├── models/        # .glb exportados desde Blender
│   ├── textures/
│   └── sounds/
└── project.godot
```

---

## 3. Usá señales para comunicar nodos, no referencias directas

Este es el error más típico. Si una defensa necesita avisarle al GameManager que mató un zombie, usá una señal:

```gdscript
# En el zombie
signal zombie_muerto(recompensa_chatarra)

func morir():
    emit_signal("zombie_muerto", 10)
```

Evitá `get_node("../../GameManager").sumar_chatarra()`. Eso crea dependencias frágiles que se rompen cuando movés nodos.

---

## 4. `delta` en `_process` es sagrado

Cualquier movimiento tiene que multiplicarse por `delta`, sino el juego va diferente en cada computadora.

```gdscript
# MAL
position.x += 5

# BIEN
position.x += 5 * delta
```

---

## 5. Autoloads para el estado global

Usá un singleton `GameState.gd` para lo que es verdaderamente global: chatarra actual, vidas de la base, oleada en curso. Se configura en **Project → Project Settings → Autoload**.

No metas todo ahí. Si empezás a guardar lógica de zombies o de torres en el GameState, se convierte en un monstruo.

```gdscript
# GameState.gd
extends Node

var chatarra: int = 0
var vidas_base: int = 10
var oleada_actual: int = 0
```

---

## 6. `@export` para balancear sin tocar código

Exponé las variables de cada defensa y zombie al editor. Así podés balancear números sin abrir un script:

```gdscript
# En cualquier defensa
@export var daño: int = 15
@export var rango: float = 4.0
@export var cadencia: float = 1.2
@export var costo_chatarra: int = 30
```

Esto es especialmente útil cuando son dos desarrollando: uno puede balancear desde el editor mientras el otro toca el código.

---

## 7. Path3D para los zombies, no NavigationAgent3D

Para un Tower Defense con camino fijo, `Path3D` + `PathFollow3D` es suficiente y mucho más simple que el pathfinding dinámico. Usá `NavigationAgent3D` solo si los zombies necesitan rodear torres colocadas dinámicamente — y eso no está en v1.

---

## 8. Git desde el día 1, sin excepción

Godot a veces crashea. Definan una convención desde el principio:

- Commit cada vez que algo funciona, aunque sea pequeño
- Cada uno trabaja en su rama para features nuevas
- Intenten no editar la misma escena al mismo tiempo (los merges de `.tscn` son dolorosos)
- Agreguen un `.gitignore` para Godot (hay plantillas listas en GitHub)

---

## 9. Flujo Blender → Godot para el low poly

El GDD ya lo define bien. Algunos tips extras:

- Exportá siempre como `.glb`, no `.obj` ni `.fbx`
- Hacé el rig de animaciones lo más simple posible (walk, attack, death para los zombies)
- Usá un modelo placeholder (cubo) para programar toda la lógica antes de tener el arte final. No esperés el modelo 3D para empezar a codear.

---

## 10. No optimicés antes de tiempo

Si tenés 30 zombies en pantalla con low poly y el juego va bien, no toques nada. Optimizá cuando tengas un problema real de performance, no antes. El 90% de las optimizaciones prematuras son tiempo tirado a la basura.

---

## 11. Seguí la hoja de ruta del GDD al pie de la letra

La tentación de saltearse hitos es enorme. El GDD ya tiene una hoja de ruta sensata:

| Hito | Qué es |
|---|---|
| Semanas 1–2 | Tutorial oficial de Godot 4, bases del engine |
| Semanas 3–4 | Un cubo que sigue Path3D y activa Game Over al llegar |
| Semanas 5–6 | Primera torre funcional con Area3D y daño |
| Semanas 7–8 | WaveManager con oleadas configurables |
| Semanas 9–10 | BuildSystem: gastar chatarra para colocar defensas |
| Semanas 11–12 | Jefe + menú + versión 1 jugable completa |
| Mes 4–6 | Arte low poly, iluminación ochentera, sonidos |
| Mes 6+ | Narrativa, zonas, Google Play |

**Regla de oro: si no terminaste el hito anterior, no arrancás el siguiente.**

---

## 12. Controlá el scope

El GDD separa bien lo que entra en v1 y lo que no. Respeten esa línea. El ciclo día/noche, el árbol de habilidades y la narrativa de la mujer enferma son post-v1, y está bien así. Lo que mata el 90% de los proyectos indie es el scope creep.

---

## 13. Nomenclatura consistente entre los dos

En GDScript la convención oficial es:

- Variables y funciones: `snake_case`
- Clases y nodos: `PascalCase`
- Constantes: `UPPER_CASE`
- Señales: `snake_case` (ej: `zombie_muerto`, `oleada_terminada`)

Definanlo antes de escribir la primera línea y respétenlo. Si uno usa camelCase y el otro snake_case el código se vuelve ilegible rápido.

---

## 14. Testear en build exportada periódicamente

El juego puede andar perfecto en el editor y tener bugs raros en la build exportada a Android. Exportá cada 2–3 semanas para detectar problemas temprano, especialmente si apuntan a Google Play.

---

## Recursos útiles

- [Documentación oficial Godot 4](https://docs.godotengine.org/en/stable/)
- [Tutorial "Your first 3D game" — Godot oficial](https://docs.godotengine.org/en/stable/getting_started/first_3d_game/index.html)
- [GDQuest en YouTube](https://www.youtube.com/@GDQuest) — mejores tutoriales de Godot 4
- [Kenney.nl](https://kenney.nl) — assets 3D gratuitos para placeholders
- [OpenGameArt.org](https://opengameart.org) — sonidos y música libres
- [BeepBox](https://beepbox.co) — música chiptune/retro en el browser
- [Gitignore para Godot](https://github.com/github/gitignore/blob/main/Godot.gitignore)
