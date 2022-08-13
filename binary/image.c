#include "image.h"

#include <stdio.h>
#include <stdlib.h>
#include <inttypes.h>

int main(int argc, char **argv){
    if(argc != 3 ){
        fprintf(stderr, "Falsche Anzahl (%d) an Argumenten, nur zwei! ", argc);
        exit(EXIT_FAILURE);
    }

    Image *image = read_image(argv[1]);
    write_bmp_image(image, argv[2]);
    free_image(image);


    return 0;
}

Image* read_image(const char *path){
    FILE *fp = NULL;
    fp = fopen(path, "rb");

    if (fp == NULL){
        fprintf(stderr, "Die Datei %s exestiert nicht oder kann nicht gelesen werden!", path);
        exit(EXIT_FAILURE);
    }

    size_t bytes; // <- counter
    for (bytes = 0; getc(fp) != EOF; ++bytes);
    fseek(fp, 0, SEEK_SET);

    Image *image = malloc(sizeof(Image));

    fread(&image->width, sizeof(image->width), 1, fp);

    fread(&image->height, sizeof(image->height), 1, fp);

    fread(&image->depth, sizeof(image->depth), 1, fp);

    if(image->depth != 3){
        fprintf(stderr, "Only RGB!");
        exit(EXIT_FAILURE);
    }

    image->pixels = malloc(sizeof(uint8_t));
    size_t counter = 0;
    while (!feof(fp)){
        image->pixels = realloc(image->pixels, sizeof(uint8_t) * (counter + 1));
        fread(&image->pixels[counter], sizeof(uint8_t), 1, fp);
        counter++;
    }
    size_t rechnung = image->depth * image->height * image->width;

    if(counter-1 != (image->depth * image->height * image->width))
    {
        fprintf(stderr, "Zuwenig Bytes in der Datei! %ld zu %ld", counter, rechnung);
        exit(EXIT_FAILURE);
    }

    fclose(fp);
    return image;
}

void write_bmp_image(const Image *image, const char *path){
    if (image->depth != 3){
        fprintf(stderr, "ERROR: Only images with a depth of 3 (3 color channels"
            ", usually RGB) are supported.\n");
        return;
    }

    FILE *file = fopen(path, "wb");

    if (!file){
        fprintf(stderr, "ERROR: Could not create file %s\n", path);
        return;
    }

    uint32_t width = image->width;
    uint32_t height = image->height;
    uint32_t size = 54 + 3 * width * height;

    // This is the BMP file header
    // https://en.wikipedia.org/wiki/BMP_file_format#File_structure
    uint8_t header[54] = {
        'B', 'M',
        size, size >> 8, size >> 16, size >> 24,
        0, 0,
        0, 0,
        54, 0, 0, 0,
        40, 0, 0, 0,
        width, width >> 8, width >> 16, width >> 24,
        height, height >> 8, height >> 16, height >> 24,
        1, 0,
        24, 0,
    };

    // Write file header to file.
    fwrite(header, 1, sizeof(header), file);

    // Write pixels to file row-by-row
    uint8_t *row = image->pixels;
    for (uint32_t y = height; y --> 0;){
        fwrite(row, 1, width * 3, file);
        // Rows in BMP files must be padded to a width which is a multiple of 4.
        for (uint32_t x = width * 3; x % 4 != 0; x++){
            fputc('\0', file);
        }
        row += width * 3;
    }

    fclose(file);
}

void free_image(Image *image){
    free(image->pixels);
    free(image);
}
