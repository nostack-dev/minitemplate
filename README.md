
# ✍️ MiniTemplate - Simple Template Engine

## Table of Contents
1. [Overview](#overview)
2. [Key Features](#key-features)
3. [Project Structure](#project-structure)
4. [How to Use](#how-to-use)
    - [Generating `index.html`](#1-generating-the-indexhtml-file)
    - [Creating New Components](#2-creating-new-components)
    - [Integrating Components into the Template](#3-integrating-components-into-the-template)
5. [Custom Theming](#custom-theming)
6. [Component Generation from Input to Output in `lib/`](#component-generation-from-input-to-output-in-lib)
7. [Testing](#testing)
8. [Contribution Guidelines](#contribution-guidelines)
9. [License](#license)

## Overview

MiniTemplate is a modular web template system designed to easily integrate various components. It leverages **Tailwind CSS** and **DaisyUI**, providing a flexible and efficient structure for statically generated web applications.

## Key Features

- **Modular Components**: Reusable components like headers, sidebars, footers, and chat inputs.
- **Template-based System**: Utilize a main `template.html` file to assemble components using a simple placeholder system (e.g., `{{lowercasenameComponent}}`).
- **Custom Theming**: Quickly change themes with the `generate.sh` script or directly using the theme controller dropdown.
- **Self-contained**: No need for complex build systems or dependencies beyond basic command-line tools.

## Project Structure

```
.
├── 🟢 createcomponent.sh [componentname]       # Create a new component (componentname is required)
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
├── CONTRIBUTING.md                             # Contribution guidelines
├── addcomponent.sh                             # Adds component from `lib/output` to the root
└── lib                                         # Library directory containing input/output components
    ├── 🟢 convert.sh                              # Script to convert components
    ├──    custom_output                           # Custom components generated from user-provided HTML
    ├──    input                                   # Source components directory
    └──    output                                  # Generated components directory
└── tests                                       # Directory containing test scripts
    ├── 🟢 run_tests.sh                             # Run all test scripts
    ├── 🟢 test_component_creation.sh               # Test component creation script
    ├── 🟢 test_component_ids.sh                    # Test that component IDs match filenames
    ├── 🟢 test_component_references.sh             # Test for invalid component references
    ├── 🟢 test_print.sh                            # Test print functionality
    └── 🟢 test_template_generation.sh              # Test template generation
```

## How to Use

### 1. Generating the `index.html` File

The core structure of the application is generated using the `generate.sh` script. This script reads `template.html` and populates it with the actual content from each component.

- **Run the script**:
  ```bash
  ./generate.sh [theme-name]
  ```
- If no theme is specified, the `data-theme` attribute will not be set, and the default DaisyUI theme will be used.

### 2. Creating New Components

To create a new component, use the `createcomponent.sh` script, which will generate the necessary HTML structure for you.

- **Run the script**:
  ```bash
  ./createcomponent.sh [componentname]
  ```
- Replace `[componentname]` with the desired name for your new component. Use a lowercase name.

The generated component structure includes:

- A `div` element with an ID corresponding to the component name.
- A button element using DaisyUI classes (`btn`) for consistent styling.
- An immediately invoked function expression (IIFE) in the script tag to ensure that JavaScript executes once the document is loaded, scoped specifically to this component.

### 3. Integrating Components into the Template

To include a component in `template.html` (or any other component you have created):

1. Use the placeholder syntax `{{componentname}}` within `template.html` where you want the component to appear.
2. Ensure the component file (e.g., `headerComponent.html`) is correctly named and located in the project root.

#### Example of Template Integration

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

The project includes a **Theme Controller** (`themecontrollerComponent.html`) that allows users to change the theme dynamically via a dropdown. Themes like "light," "dark," "cupcake," "cyberpunk," and many more are available.

1. The `themecontrollerComponent` is used to switch between themes; local storage is used to store the selection.
2. The selected theme is applied immediately to the page by updating the `data-theme` attribute.

Available themes include but are not limited to:

- light
- dark
- cupcake
- bumblebee
- emerald
- corporate
- synthwave
- business
- cyberpunk

For a complete list, [click here](https://daisyui.com/docs/themes/)

## Component Generation from Input to Output in `lib/`

The `lib/` directory contains subdirectories for managing component transformations:

- **`lib/input/`**: Contains the source components in their base form. These are simple components using DaisyUI and Tailwind CSS, with no extra JavaScript logic or complex styling applied.
- **`lib/output/`**: Contains the transformed or enhanced versions of the components.
- **`lib/custom_output/`**: Stores user-generated custom components created with custom HTML using the `convert.sh` script.

### How It Works:

- **Transform All Components**:
  ```bash
  ./lib/convert.sh
  ```
  This reads all HTML files in `lib/input/` and outputs them as self-contained components in `lib/output/`.

- **Generate a Custom Component**:
  ```bash
  ./lib/convert.sh [customname] '<custom_html>'
  ```
  This generates `lib/custom_output/[customname]customComponent.html` with your provided HTML.

The generated components in `lib/output/` and `lib/custom_output/` are fully usable components that can be integrated directly into the `template.html` file or any other page.

### Example Workflow

1. **Convert Components**: Use `convert.sh` to convert all HTML files in `lib/input/` (DaisyUI components) into reusable MiniTemplate components:
   ```bash
   ./lib/convert.sh
   ```
2. **Add Component to Project Root**: Use `addcomponent.sh` to copy a component from `lib/output/` to the project root:
   ```bash
   ./addcomponent.sh button
   ```
3. **Integrate Component in Template**: Add `{{buttonComponent}}` to the desired location in `template.html`.
4. **Generate the Final HTML**: Run `generate.sh` to compile `index.html`:
   ```bash
   ./generate.sh [theme-name]
   ```

## Testing

To ensure the integrity of the components and templates, the project includes a set of automated tests located in the `tests` directory. These tests cover:

- **Component Creation**: Validating that components are correctly created.
- **Template Generation**: Ensuring that the template is properly generated.
- **Print Functionality**: Testing the print script to ensure it outputs the correct structure.
- **Invalid Component References**: Verifying that no invalid component references exist in the templates.

### Running Tests

- **Run all tests**:
  ```bash
  cd ./tests
  ./run_tests.sh
  ```

### Test Output Example

Below is an example of what you might see when running the tests:

```bash
-----------------------------------
## Running Tests

- ✅ Test passed: `../tests/test_component_creation.sh`
- ✅ Test passed: `../tests/test_component_ids.sh`
- ✅ Test passed: `../tests/test_component_references.sh`
- ✅ Test passed: `../tests/test_print.sh`
- ✅ Test passed: `../tests/test_template_generation.sh`

### Test Summary
-----------------------------------
All tests passed.

Total Tests Passed: 5
Total Tests Failed: 0

🟢 All tests finished.
```

## Contribution Guidelines

We welcome contributions to MiniTemplate! If you'd like to contribute, please read our [Contribution Guidelines](CONTRIBUTING.md) before getting started.

### Quick Steps:

1. **Reporting Issues**: If you encounter any bugs or have suggestions, please open an issue on the [issue tracker](https://github.com/nostack-dev/minitemplate/issues).
2. **Feature Requests**: Have an idea for a new feature? Open a new issue and describe it in detail.
3. **Submitting Pull Requests**:
   - Fork the repository.
   - Create a new branch off of `main` for your changes.
   - Commit your changes with clear messages.
   - Push your branch and open a pull request.

Please ensure that your code follows our style guidelines, is well-documented, and includes tests where appropriate.

## License

This project is licensed under the [MIT License](LICENSE). You are free to use, modify, and distribute this software in accordance with the terms of the license.
