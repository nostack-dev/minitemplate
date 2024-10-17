# ✍️ MiniTemplate - Simple Template Engine

## Overview

MiniTemplate is a modular web template system designed to easily integrate various components. It leverages **Tailwind CSS** and **DaisyUI**, providing a flexible and efficient structure for dynamic web applications.

## Key Features

- **Modular Components**: Reusable components like headers, sidebars, footers, and chat inputs.
- **Template-based System**: Utilize a main `template.html` file to assemble components using a simple placeholder system (e.g., `{{component}}`).
- **Authentication Integration**: Easy management of login and session states using Keycloak through `keycloakComponent.html`.
- **Custom Theming**: Quickly change themes with the `generate.sh` script.

## Project Structure

The project consists of the following files and components:

```
.
├── chatinputComponent.html      # Chat input UI with a send button
├── contentComponent.html        # Main content area for dynamic display
├── createcomponent.sh           # Script to create new components
├── footerComponent.html         # Footer with copyright and scripts
├── generate.sh                  # Script to generate index.html
├── headerComponent.html         # Header with model dropdown and login
├── index.html                   # Main entry point for the application
├── keycloakComponent.html       # Handles Keycloak authentication
├── modeldropdownComponent.html   # Dropdown for selecting models
├── ollamachatComponent.html     # UI for Ollama chat interaction
├── openaichatComponent.html     # Chat component integrating OpenAI chat
├── print.sh                     # Script to display directory structure
├── README.md                    # Documentation for the project
├── sidebarComponent.html        # Sidebar with navigation and toggling
└── template.html                # Template file combining all components
```

## How to Use

### 1. Generating the Index File

The core structure of the application is generated using the `generate.sh` script. This script reads `template.html` and populates it with the actual content from each component.

- **Run the script**:
  ```bash
  ./generate.sh [theme-name]
  ```
- If no theme is specified, the default theme (`business`) will be applied.

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

## Conclusion

MiniTemplate is designed for developers who want to streamline their web development process by utilizing modular, reusable components. By following the structure and usage guidelines provided, you can efficiently create and manage your web applications with ease.

For further assistance or contributions, feel free to reach out or contribute to the project!

---
