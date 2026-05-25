# Notas

## Funciones especiales
En Godot, hay varias funciones que tienen nombres especiales para que el editor las interprete de determinadas maneras:
- `_ready()`: se ejecuta una sola vez cuando el nodo aparece en la escena
- `process(delta)`: se ejecuta cada frame visual (60fps, 120fps, lo que tenga le monitor)
- `physics_process(delta)`: se ejecuta a frecuencia fija, 60 veces por segundo siempre, sin importar los FPS