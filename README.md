# ✍️ MiniTemplate - Simple Template Engine

## Overview

MiniTemplate is a modular web template system designed to easily integrate various components. It leverages **Tailwind CSS** and **DaisyUI**, providing a flexible and efficient structure for statically generated web applications.

## Key Features

- **Modular Components**: Reusable components like headers, sidebars, footers, and chat inputs.
- **Template-based System**: Utilize a main `template.html` file to assemble components using a simple placeholder system (e.g., `{{component}}`).
- **Custom Theming**: Quickly change themes with the `generate.sh` script or directly using the theme controller dropdown.

## Project Structure

The flat project structure is intentional to improve development speed by providing direct access to all components without deep navigation. Further structure can be added as the project scales to accommodate more complexity while maintaining this simplicity.

The project consists of the following files and components:

```html
.
├── 🟢 createcomponent.sh [name]         # Create a new component (name is required)
├── 🟢 generate.sh [theme]               # Generate index.html with optional theme
├── 🟢 print.sh .                        # Print current directory structure and files
├── template.html                        # Base file used to generate index.html
├── index.html                           # Generated from template.html
├── headerComponent.html                 # Header with theme controller
├── contentComponent.html                # Main content area
├── sidebarComponent.html                # Sidebar with navigation
├── themecontrollerComponent.html        # Theme controller dropdown
├── footerComponent.html                 # Footer content
└── README.md                            # Project documentation
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

#### Example Component Structure

```html
<!-- buttonComponent.html -->
<div id="buttonComponent">
    <!-- Add your component HTML here -->
    <button class="btn">Action</button>

    <script>
        // Add your component-specific JavaScript here
        (function() {
            // Ensures the script runs only after the document is fully loaded
            document.addEventListener('DOMContentLoaded', function() {
                console.log('button component loaded.');
            });
        })();
    </script>
</div>
```

- **Why use an Immediate Function?**
  - The immediate function, also known as an Immediately Invoked Function Expression (IIFE), ensures that the JavaScript within the component is self-contained and doesn't interfere with other components. This keeps the scope of variables and functions limited to this component, promoting modularity and avoiding conflicts.

- **Scoped Tailwind and DaisyUI CSS**
  - The use of DaisyUI ensures that the styles are consistent and scoped to the elements using DaisyUI classes like `btn`. This approach helps keep the styling modular and easily maintainable, while also providing a visually appealing design out of the box.

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
- business
- cyberpunk

For a complete list [click here](https://daisyui.com/docs/themes/)

## daisyUI

MiniTemplate uses daisyUI for modular scoped Tailwind CSS components. You can [visit daisyUI documentation](https://daisyui.com/components/) to see all available components, themes, and their documentation.

For further assistance or contributions, feel free to reach out or contribute to the project!

---
