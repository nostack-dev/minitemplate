
# ✍️ MiniTemplate - Simple Template Engine

## Table of Contents
1. [Overview](#overview)
2. [Key Features](#key-features)
3. [Project Structure](#project-structure)
4. [How to Use](#how-to-use)
    - [Generating index.html](#1-generating-the-indexhtml-file)
    - [Creating New Components](#2-creating-new-components)
    - [Integrating Components into the Template](#3-integrating-components-into-the-template)
5. [Custom Theming](#custom-theming)
6. [Component Generation from Input to Output](#component-generation-from-input-to-output-in-lib)
7. [Testing](#testing)
8. [Contribution Guidelines](#contribution-guidelines)
9. [License](#license)

## Overview

MiniTemplate is a modular web template system designed to easily integrate various components. It leverages **Tailwind CSS** and **DaisyUI**, providing a flexible and efficient structure for statically generated web applications.

## Key Features

- **Modular Components**: Reusable components like headers, sidebars, footers, and chat inputs.
- **Template-based System**: Utilize a main `template.html` file to assemble components using a simple placeholder system (e.g., `{{component}}`).
- **Custom Theming**: Quickly change themes with the `generate.sh` script or directly using the theme controller dropdown.

## Project Structure

```
.
├── 🟢 createcomponent.sh [componentName]       # Create a new component (componentName is required)
├── 🟢 generate.sh [theme]                      # Generate `index.html` with an optional theme
├── 🟢 print.sh                                 # Print current directory structure and files
├── template.html                               # Base file used to generate `index.html`
├── index.html                                  # Generated from `template.html`
├── headerComponent.html                        # Header with theme controller
├── contentComponent.html                       # Main content area
├── sidebarComponent.html                       # Sidebar with navigation
├── heroComponent.html                          # Hero section component
├── themecontrollerComponent.html               # Theme controller dropdown
├── footerComponent.html                        # Footer content
├── README.md                                   # Project documentation
├── addcomponent.sh                             # Adds component from lib/output to the root
└── lib                                         # Library directory containing input/output components
    ├── input                                   # Source components directory
    └── output                                  # Generated components directory
└── tests                                       # Directory containing test scripts
    ├── 🟢 run_tests.sh                         # Run all test scripts
    ├── 🟢 test_component_creation.sh           # Test component creation script
    ├── 🟢 test_component_ids.sh                # Test that component IDs match filenames
    ├── 🟢 test_component_references.sh         # Test for invalid component references
    ├── 🟢 test_print.sh                        # Test print functionality
    └── 🟢 test_template_generation.sh          # Test template generation
```

## How to Use

### 1. Generating the index.html File

The core structure of the application is generated using the `generate.sh` script. This script reads `template.html` and populates it with the actual content from each component.

- **Run the script**:
  ```bash
  ./generate.sh [theme-name]
  ```
- If no theme is specified, the default theme will be applied. If no theme is provided, the `data-theme` attribute will not be set.

### 2. Creating New Components

To create a new component, use the `createcomponent` script, which will generate the necessary HTML structure for you.

- **Run the script**:
  ```bash
  ./createcomponent.sh [componentName]
  ```
- Replace `[componentName]` with the desired name for your new component.

The generated component structure includes:

- A `div` element with an ID corresponding to the component name.
- A button element using DaisyUI classes (`btn`) for consistent styling.
- An immediately invoked function expression (IIFE) in the script tag to ensure that JavaScript executes once the document is loaded, scoped specifically to this component.

### 3. Integrating Components into the Template

To include a component in `template.html` (or any other component you have created):

1. Use the placeholder syntax `{{componentName}}` within `template.html` where you want the component to appear.
2. Ensure the component file (e.g., `headerComponent.html`) is correctly named and located in the project root.

### Example of Template Integration

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Your Page Title</title>
    <!-- Include CSS and scripts here -->
</head>
<body>
    {{headerComponent}} <!-- Header integration -->
    {{contentComponent}} <!-- Main content integration -->
    {{footerComponent}} <!-- Footer integration -->
</body>
</html>
```

## Custom Theming

The project now includes a **Theme Controller** (`themecontrollerComponent.html`) that allows users to change the theme dynamically via a dropdown. Themes like "light," "dark," "cupcake," "cyberpunk," and many more are available. To update the theme:

1. The  `themecontrollerComponent` is used to switch between themes, local storage is used to store the selection.
2. The selected theme will be applied immediately to the page by updating the `data-theme` attribute.

The available themes include but are not limited to:

- light
- dark
- cupcake
- bumblebee
- emerald
- corporate
- synthwave
- business
- cyberpunk

For a complete list [click here](https://daisyui.com/docs/themes/)

## Component Generation from Input to Output in `lib/`

The `lib/` directory contains two subdirectories: `input/` and `output/`. These directories handle the transformation of components from their source form (`input/`) to their generated version (`output/`). The `custom_output/` directory stores user-defined custom components.

### How It Works:

- **`lib/input/`**: Contains the source components in their base form. These are simple components using DaisyUI and Tailwind CSS, with no extra JavaScript logic or complex styling applied.
- **`lib/output/`**: This is where the transformed or enhanced version of the component is saved.
- **`lib/custom_output/`**: This directory stores user-generated custom components that were created with custom HTML using the `convert.sh` script.

### Example

To transform a component from `input/` to `output/`, you would run:

```bash
./lib/convert.sh
```

This would read all html files in `lib/input` and output them as self-contained components in `lib/output/`.

To generate a custom component from provided HTML:

```bash
./lib/convert.sh [customname] '<custom_html/>'
```

This would generate `lib/custom_output/[customname]customComponent.html` with your provided HTML.

The generated components in `lib/output/` and `lib/custom_output/` are fully usable components that can be integrated directly into the `template.html` file or any other page.

### Example Workflow

1. Use `convert.sh` to generate the components:
   ```bash
   ./lib/convert.sh button
   ```
2. Integrate the component in your template by adding `{{buttonComponent}}` to the desired location in `template.html`.

3. Run `generate.sh` to compile `index.html`:
   ```bash
   ./generate.sh [theme-name]
   ```

## Contribution Guidelines

We welcome contributions to MiniTemplate! If you have ideas for new features, bug fixes, or improvements, feel free to open a pull request. Before contributing, please check the [Contribution Guidelines](CONTRIBUTING.md).

## License

This project is licensed under the MIT License.
