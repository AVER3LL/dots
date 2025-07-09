#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <libgen.h> // For dirname and basename (though not strictly used in this version)
#include <dirent.h> // For directory operations
#include <unistd.h> // For access
#include <sys/wait.h> // Not needed for this specific script, but good to keep in mind for related tasks

#define MAX_PATH 4096
#define MAX_FILENAME 255
#define INITIAL_ROFI_INPUT_BUFFER_SIZE (1024 * 10) // Start with 10KB, will realloc
#define REALLOC_INCREMENT (1024 * 5)              // Increase by 5KB if needed

#define WALLPAPER_THUMBS_DIR "%s/.cache/wallpaper-thumbs"
#define WALLPAPER_DIR "%s/wallpaper"

// Function to check if a directory exists
int dir_exists(const char *path) {
    return access(path, F_OK) == 0;
}

// Function to escape special characters for thumbnail filename
// Replaces non-alphanumeric, non-dot, non-underscore, non-hyphen with underscore
void escape_filename(const char *input, char *output, size_t output_size) {
    size_t i = 0, j = 0;
    while (input[i] != '\0' && j < output_size - 1) {
        if ((input[i] >= 'a' && input[i] <= 'z') ||
            (input[i] >= 'A' && input[i] <= 'Z') ||
            (input[i] >= '0' && input[i] <= '9') ||
            input[i] == '.' || input[i] == '_' || input[i] == '-') {
            output[j++] = input[i];
        } else {
            output[j++] = '_';
        }
        i++;
    }
    output[j] = '\0';
}

int main() {
    // Configuration - Read from environment variables
    const char *home_dir = getenv("HOME");
    if (home_dir == NULL) {
        fprintf(stderr, "Error: HOME environment variable not set.\n");
        return 1;
    }

    char wall_dir[MAX_PATH];
    snprintf(wall_dir, sizeof(wall_dir), WALLPAPER_DIR, home_dir);

    char thumb_dir[MAX_PATH];
    snprintf(thumb_dir, sizeof(thumb_dir), WALLPAPER_THUMBS_DIR, home_dir);

    // Check if wallpaper directory exists
    if (!dir_exists(wall_dir)) {
        fprintf(stderr, "Error: Wallpaper directory not found: %s\n", wall_dir);
        return 1;
    }

    // Find all supported image files
    // Using popen to execute find command and read its output
    char find_cmd[MAX_PATH * 2];
    snprintf(find_cmd, sizeof(find_cmd), "find \"%s\" -type f \\( -iname \"*.jpg\" -o -iname \"*.jpeg\" -o -iname \"*.png\" -o -iname \"*.gif\" -o -iname \"*.webp\" -o -iname \"*.bmp\" \\) -printf \"%%P\\n\" | shuf", wall_dir);

    FILE *fp = popen(find_cmd, "r");
    if (fp == NULL) {
        perror("Failed to run find command");
        return 1;
    }

    char **image_files = NULL;
    int num_image_files = 0;
    char line[MAX_PATH];

    while (fgets(line, sizeof(line), fp) != NULL) {
        // Remove newline character
        line[strcspn(line, "\n")] = 0;
        num_image_files++;
        image_files = realloc(image_files, num_image_files * sizeof(char *));
        if (image_files == NULL) {
            perror("Failed to reallocate memory for image files");
            pclose(fp);
            return 1;
        }
        image_files[num_image_files - 1] = strdup(line);
        if (image_files[num_image_files - 1] == NULL) {
            perror("Failed to duplicate string for image file");
            pclose(fp);
            for (int i = 0; i < num_image_files - 1; i++) {
                free(image_files[i]);
            }
            free(image_files);
            return 1;
        }
    }
    pclose(fp);

    // Check if any wallpapers were found
    if (num_image_files == 0) {
        fprintf(stderr, "No wallpapers found in %s\n", wall_dir);
        return 0; // Exit successfully, but with no output
    }

    // Build the rofi menu input string
    char *rofi_input_buffer = malloc(INITIAL_ROFI_INPUT_BUFFER_SIZE);
    if (rofi_input_buffer == NULL) {
        perror("Failed to allocate initial memory for Rofi input buffer");
        for (int i = 0; i < num_image_files; i++) {
            free(image_files[i]);
        }
        free(image_files);
        return 1;
    }
    size_t current_rofi_input_len = 0;
    size_t rofi_input_buffer_capacity = INITIAL_ROFI_INPUT_BUFFER_SIZE;

    for (int i = 0; i < num_image_files; i++) {
        char *file = image_files[i];
        char escaped_file[MAX_FILENAME];
        escape_filename(file, escaped_file, sizeof(escaped_file));

        char thumb_file[MAX_PATH];
        snprintf(thumb_file, sizeof(thumb_file), "%s/%s.jpg", thumb_dir, escaped_file);

        // Calculate required space for this entry
        // filename + \0 + icon + \x1f + thumb_file + \n
        size_t required_space = strlen(file) + 1 + strlen("icon") + 1 + strlen(thumb_file) + 1;

        // Check if buffer needs to be resized
        if (current_rofi_input_len + required_space > rofi_input_buffer_capacity) {
            size_t new_capacity = rofi_input_buffer_capacity + REALLOC_INCREMENT;
            // Ensure new capacity is at least what's needed
            while (current_rofi_input_len + required_space > new_capacity) {
                new_capacity += REALLOC_INCREMENT;
            }

            char *temp_buffer = realloc(rofi_input_buffer, new_capacity);
            if (temp_buffer == NULL) {
                perror("Failed to reallocate memory for Rofi input buffer");
                free(rofi_input_buffer); // Free existing buffer before exiting
                for (int j = 0; j < num_image_files; j++) {
                    free(image_files[j]);
                }
                free(image_files);
                return 1;
            }
            rofi_input_buffer = temp_buffer;
            rofi_input_buffer_capacity = new_capacity;
        }

        // Append to the buffer using memcpy for null bytes and snprintf for strings
        memcpy(rofi_input_buffer + current_rofi_input_len, file, strlen(file));
        current_rofi_input_len += strlen(file);

        rofi_input_buffer[current_rofi_input_len++] = '\0'; // Add null byte

        memcpy(rofi_input_buffer + current_rofi_input_len, "icon", strlen("icon"));
        current_rofi_input_len += strlen("icon");

        rofi_input_buffer[current_rofi_input_len++] = '\x1f'; // Add unit separator

        memcpy(rofi_input_buffer + current_rofi_input_len, thumb_file, strlen(thumb_file));
        current_rofi_input_len += strlen(thumb_file);

        rofi_input_buffer[current_rofi_input_len++] = '\n'; // Add newline
    }

    // Print the entire buffer to stdout
    // fwrite is used to print raw bytes, including null characters
    fwrite(rofi_input_buffer, 1, current_rofi_input_len, stdout);

    // Free all dynamically allocated memory
    free(rofi_input_buffer);
    for (int i = 0; i < num_image_files; i++) {
        free(image_files[i]);
    }
    free(image_files);

    return 0;
}
