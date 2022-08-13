#include <stdint.h>


typedef struct {
    uint8_t *pixels;
    uint64_t width;
    uint32_t height;
    uint16_t depth;
} Image;

Image* read_image(const char *path);
void write_bmp_image(const Image *image, const char *path);
void free_image(Image *image);
