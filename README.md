
# ✍️ MiniTemplate - Simple Template Engine

## Overview

MiniTemplate is a modular web template system designed to easily integrate various components. It leverages **Tailwind CSS** and **DaisyUI**, providing a flexible and efficient structure for dynamic web applications.

## Key Features

- **Modular Components**: Reusable components like headers, sidebars, footers, and chat inputs.
- **Template-based System**: Utilize a main `template.html` file to assemble components using a simple placeholder system (e.g., `{{component}}`).
- **Authentication Integration**: Easy management of login and session states using Keycloak through `keycloakComponent.html`.
- **Custom Theming**: Quickly change themes with the `generate.sh` script or directly using the theme controller dropdown.

## Project Structure

The flat project structure is intentional to improve development speed by providing direct access to all components without deep navigation. Further structure can be added as the project scales to accommodate more complexity while maintaining this simplicity.

The project consists of the following files and components:

```bash
.
├── contentComponent.html        # Main content area for dynamic display
├── createcomponent.sh           # Script to create new components
├── footerComponent.html         # Footer with copyright and scripts
├── generate.sh                  # Script to generate index.html with optional theme support
├── headerComponent.html         # Header including the theme controller
├── index.html                   # Main entry point for the application
├── print.sh                     # Script to display directory structure
├── README.md                    # Documentation for the project
├── sidebarComponent.html        # Sidebar with navigation and toggling
├── template.html                # Template file combining all components
└── themecontrollerComponent.html # Theme controller dropdown for changing site themes
```

## How to Use

### 1. Generating the Index File

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

### 3. Integrating Components into the Template

To include a component in `template.html`:

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

1. Use the `themecontrollerComponent` integrated into the header.
2. The selected theme will be applied immediately to the page by updating the `data-theme` attribute.

The available themes include but are not limited to:

- light
- dark
- cupcake
- bumblebee
- emerald
- corporate
- synthwave
- retro
- cyberpunk
- valentine
- aqua
- lofi
- pastel
- fantasy
- wireframe
- black
- luxury
- dracula
- cmyk
- autumn
- acid
- lemonade
- night
- coffee
- winter
- dim
- nord
- sunset

## daisyUI

MiniTemplate uses daisyUI for modular scoped Tailwind CSS components. You can [click here](https://daisyui.com/components/) to see all available components, themes and their documentation.

For further assistance or contributions, feel free to reach out or contribute to the project!

---

