CXX := clang++
CXXFLAGS := -fasm-blocks -mavx2 -O2 -std=c++17 $(shell pkg-config --cflags Qt6Widgets)
LDFLAGS := $(shell pkg-config --libs Qt6Widgets)
SRCS := main.cpp MainWindow.cpp GridWidget.cpp
OBJS := $(SRCS:.cpp=.o)
TARGET := app.exe

.PHONY: all clean

all: $(TARGET)

$(TARGET): $(OBJS)
	$(CXX) $(CXXFLAGS) -o $@ $(OBJS) $(LDFLAGS)

%.o: %.cpp
	$(CXX) $(CXXFLAGS) -c $< -o $@

clean:
	rm -f $(OBJS) $(TARGET)
