#include <stdio.h>
#include <stdlib.h>
#include "config.h"
#include "SDL2/SDL.h"
#include "SDL2/SDL_image.h"

int main(int argc, char **argv)
{
  if (SDL_Init(SDL_INIT_EVERYTHING) != 0) {
    printf("An error has occured whilst initializing SDL: %s", SDL_GetError());
    exit(EXIT_FAILURE);
  }

  //Create the window.
  SDL_Window *window = SDL_CreateWindow(WINDOW_CAPTION, SDL_WINDOWPOS_UNDEFINED, SDL_WINDOWPOS_UNDEFINED, WINDOW_WIDTH, WINDOW_HEIGHT,SDL_WINDOW_SHOWN | SDL_WINDOW_ALLOW_HIGHDPI);
  if (window == NULL) {printf("SDL failed to instatiate a window."); exit(EXIT_FAILURE);}

  //Create the renderer for the window.
  SDL_Renderer *renderer = SDL_CreateRenderer(window, -1, SDL_RENDERER_ACCELERATED);
  if (renderer == NULL) {printf("SDL failed to instatiate a render."); exit(EXIT_FAILURE);}

  SDL_Event window_event;
  
  SDL_bool shouldClose = SDL_FALSE;
  while (shouldClose == SDL_FALSE)
  {
    while (SDL_PollEvent(&window_event)) {
      if (window_event.type == SDL_QUIT) {shouldClose = SDL_TRUE;}
    }
    Uint8 *keyboard_keys = SDL_GetKeyboardState(NULL);
    if (keyboard_keys[SDL_SCANCODE_ESCAPE]) {shouldClose = SDL_TRUE;}

    SDL_RenderClear(renderer);
    SDL_RenderPresent(renderer);
    SDL_Delay(1000/50);
  }

  SDL_DestroyRenderer(renderer);
  SDL_DestroyWindow(window);
  SDL_Quit();

  return (EXIT_SUCCESS);
}
