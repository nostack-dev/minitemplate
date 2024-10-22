# ✍️ MiniTemplate - Simple Template Engine

## Overview
MiniTemplate is a modular web template system designed to easily integrate various components. It leverages Tailwind CSS and DaisyUI, providing a flexible and efficient structure for statically generated web applications.

## Key Features
- **Modular Components**: Reusable components like headers, sidebars, footers, and hero sections.
- **Template-based System**: Assemble components with placeholders (e.g., `{{componentName}}`) to populate `template.html`.
- **Custom Theming**: Quickly change themes with the `generate.sh` script or via the theme controller dropdown.

## Project Structure
The project follows a flat structure for ease of navigation. As the project scales, more structure can be added as necessary.

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
├── CNAME                                       # Domain name configuration
└── tests                                       # Directory containing test scripts
    ├── 🟢 run_tests.sh                         # Run all test scripts
    ├── 🟢 test_component_creation.sh           # Test component creation script
    ├── 🟢 test_component_ids.sh                # Test that component IDs match filenames
    ├── 🟢 test_component_references.sh         # Test for invalid component references
    ├── 🟢 test_print.sh                        # Test print functionality
    └── 🟢 test_template_generation.sh          # Test template generation
```

## How to Use

### 1. Generating the `index.html` File
Use the `generate.sh` script to populate `template.html` with content from each component:

```bash
./generate.sh [theme-name]
```

If no theme is specified, the default theme will be applied.

### 2. Creating New Components
To create a new component, run the `createcomponent.sh` script:

```bash
./createcomponent.sh [componentName]
```

The script generates the necessary HTML structure with a scoped IIFE for modular JavaScript functionality.

### 3. Integrating Components into the Template
Include components in `template.html` using placeholders:

```html
{{headerComponent}} <!-- Header integration -->
{{contentComponent}} <!-- Main content integration -->
{{footerComponent}}  <!-- Footer integration -->
```

### Custom Theming
Use the `themecontrollerComponent.html` to switch themes dynamically with DaisyUI. Available themes include:

- light
- dark
- cupcake
- cyberpunk

### Testing
Run all test scripts with:

```bash
./tests/run_tests.sh
```

These scripts test component creation, template generation, and other core functionalities.

