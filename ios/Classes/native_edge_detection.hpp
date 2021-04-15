struct Coordinate
{
    double x;
    double y;
};

struct DetectionResult
{
    Coordinate* topLeft;
    Coordinate* topRight;
    Coordinate* bottomLeft;
    Coordinate* bottomRight;
};

extern "C"
struct ProcessingInput
{
    char* path;
    char* tempPath;
    DetectionResult detectionResult;
};

extern "C"
struct DetectionResult *detect_edges(char *str);

extern "C"
bool rotate_image(char* path);

extern "C"
bool process_image(
    char* path,
    char* tempPath,
    double topLeftX,
    double topLeftY,
    double topRightX,
    double topRightY,
    double bottomLeftX,
    double bottomLeftY,
    double bottomRightX,
    double bottomRightY
);