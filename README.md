# ✍️ MiniTemplate - Simple Template Engine

This guide will walk you through setting up a MiniTemplate project, adding components, templates, and generating the static `index.html` file as result.

## Directory Structure Overview

```console
.
├── run_create_project.sh # create a new project
├── components
│   ├── converted         # Converted components ready for use in the project
│   ├── default           # Default components provided by MiniTemplate
│   ├── custom            # Custom user-defined components
│   ├── source            # Source components to be converted
├── public                # Final static site can be served from here
├── scripts               # Utility scripts for generating the site
├── templates             # HTML template for the project
├── tests                 # Test scripts to validate MiniTemplate functionality
```

## Step 1: Setting Up Your Project

### Clone the repository

```console
git clone https://github.com/nostack-dev/minitemplate.git
cd minitemplate
```

Ensure all the files and directories listed in the directory structure are present before proceeding.

### Run `run_create_project.sh`

This script will create a new project directory with default components and templates.

```console
chmod +x run_create_project.sh && ./run_create_project.sh
```

You will be prompted to provide a name for your project. Once done, the script will generate a new project directory under `projects/` with the necessary components and templates copied over.

When prompted for a project name, use:

```console
myproject
```

Then navigate to your created project:

```console
cd ./projects/myproject
```

This will create a new folder `projects/myproject` with the default components and scripts inside.

Default components are automatically added during project creation. If needed, you can override them using the `run_add.sh defaults` command, but this is not the main focus.

## Step 2: Adding Components to Your Project

MiniTemplate allows you to easily add components to your project using the `run_add.sh` script.

### List Available Components

To list all available components, run the `run_add.sh` script without any arguments inside your project directory:

```console
./run_add.sh
```

You will see a list of components from `components/default`, `components/custom`, and `components/converted`.

### Add Specific Components

To add a specific component to your project, pass the component name as an argument to `run_add.sh`:

```console
./run_add.sh button
```

This will copy the `button.html` component into your project directory.

After adding a component, you can embed it in any template or component file using the `{{component_name}}` syntax. For example, to use the button component, add `{{button}}` to your template file.

## Step 3: Adding Template Variables and Generating the Static Site

Once you have all the necessary components in place, you can integrate them into your templates using the `{{component_name}}` syntax. This allows for nesting components within templates or even within other components.

For example, to include a `button` component within a template, simply add `{{button}}` to the desired location in your template file.

### Generate the Static Site

From your project directory, run:

```console
./run_generate_site.sh
```

The script processes the main template (`template_default.html`), replacing placeholders (e.g., `{{header_default}}`) with the appropriate component files. The resulting `index.html` can be served directly on any static web host, such as GitHub Pages.

After generating the site, you can copy the `index.html` file to the `public` directory:

```console
cp index.html ../../public/
```

This will allow the static site to be served from the `public` directory if desired. 

### Placeholders
Any template file or component HTML file can include other components using the `{{component}}` syntax. When you run `run_generate_site.sh` from your project folder, these placeholders are replaced by the actual component contents.

### Example: Using Template Variables

Here is an example of how `{{}}` placeholders are used within a template file (or any other Component):

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Project</title>
</head>
<body>
    {{header_default}}
    <main>
        <h1>Welcome to My Project</h1>
        {{button}}
    </main>
    {{footer_default}}
</body>
</html>
```

In this example, the `{{header_default}}`, `{{button}}`, and `{{footer_default}}` placeholders are replaced with their respective component contents during the generation process.

## Step 4: Testing the Setup

You can run a suite of tests to ensure that your setup is working as expected.

### Run the Tests

Navigate to the `tests` directory, then run:

```console
cd ./tests && ./run_tests.sh
```

This will execute the test suite found in the `tests/` directory and validate your project’s setup, components, and templates.

Example output:

```console
### Test Start
---------------------------------

## Running Tests

✔ Test passed: ./test_addcomponent.sh
✔ Test passed: ./test_component_ids.sh
✔ Test passed: ./test_component_references.sh
✔ Test passed: ./test_index_served.sh
✔ Test passed: ./test_print.sh
✔ Test passed: ./test_template_generation.sh

### Test Summary
---------------------------------
✔ All tests passed!
---------------------------------

Total Tests Passed: 6
Total Tests Failed: 0

All tests finished.
```

If all tests pass, you’ll receive a success message. If any tests fail, check the logs to identify the issue.

## Additional Step: Converting Source Components (Optional)

MiniTemplate allows you to transform raw components from `components/source`, which are basic DaisyUI HTML-files, into usable MiniTemplate components in `components/converted`. See all daisyUI-Components  [here]([url](https://daisyui.com/components/button/)).

### Convert Components

Navigate to the `scripts` directory and use the `convert_components.sh` script to convert all raw components:

```console
cd ./scripts && ./convert_components.sh
```

This will read all HTML files in the `source` directory and convert them into self-contained components, which will be placed in the `converted` directory.

### Structure Comparison: Source vs Converted

- **Source Component Example (Basic DaisyUI HTML):**

  ```html
  <div class="alert">
    <span>Alert message here!</span>
  </div>
  ```

- **Converted Component Example (MiniTemplate Component):**

  ```html
  <div id="alert_component">
    <div class="alert">
      <span>Alert message here!</span>
    </div>
    <script>
      (function() {
        // Component-specific JavaScript
      })();
    </script>
  </div>
  ```

The converted components are self-contained and modular, allowing for easy reuse and consistent styling throughout your project. Each component includes a JavaScript block for additional behavior, making them more powerful compared to the basic DaisyUI HTML.

## MiniTemplate-Components Don’t Look Special or New—What Sets Them Apart?

At first glance, MiniTemplate components may seem like standard HTML, but their design offers distinct advantages:

```html
<div id="alert_component"> <!-- Auto-generated ID -->
  <div class="alert"> <!-- Collision-free DaisyUI style-classes -->
    <span>Alert message here!</span>
  </div>
  <script>
    (function() { // Isolation of JavaScript using an IIFE
      let isOpen = true; // Local state variable for alert status
      // Component-specific JavaScript
      if (isOpen) {
        console.log("Alert is open");
      }
    })();
  </script>
</div>
```

- **Auto-Generated Unique ID:** Ensures each component is uniquely identifiable, preventing duplication.
- **Collision-Free DaisyUI Styles:** Inline Tailwind CSS ensures that styles remain modular and do not interfere with others.
- **Isolation of JavaScript:** Uses an immediately invoked function expression (IIFE) to prevent conflicts and enhance reliability.
- **Local State Management:** Local state variables, like `isOpen`, can be utilized to manage component behavior within the function.

This combination results in a powerful, scalable approach to web development without adding unnecessary complexity, along with the option to integrate state management tools.

Refer to [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines on how to contribute and see [LICENSE](LICENSE) for licensing information.

Thanks to [TailwindCSS](https://tailwindcss.com) and [daisyUI](https://daisyui.com/) for their great work.
