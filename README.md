# ✍️ MiniTemplate - Simple Template Engine

This guide will walk you through setting up a MiniTemplate project, converting components, adding templates, and finally generating a static `index.html` file. The setup is divided into several parts to ease integration and usage.

## Directory Structure Overview

```shell
.
├── components
│   ├── converted        # Converted components ready for use in the project
│   ├── default          # Default components provided by MiniTemplate
│   ├── custom           # Custom user-defined components
│   ├── source           # Source components to be converted
├── public               # Final static site will be here
├── scripts              # Utility scripts for generating the site
├── templates            # HTML templates for the project
├── tests                # Test scripts to validate MiniTemplate functionality
├── LICENSE              # License information for MiniTemplate
└── CONTRIBUTE.md        # Contribution guidelines
```

## Step 1: Setting Up Your Project

### Clone the repository

```bash
git clone https://github.com/nostack-dev/minitemplate.git
cd minitemplate
```

Ensure all the files and directories listed in the directory structure are present before proceeding.

### Run `run_create_project.sh`

This script will create a new project directory with default components and templates.

```bash
chmod +x run_create_project.sh && ./run_create_project.sh
```

You will be prompted to provide a name for your project. Once done, the script will generate a new project directory under `projects/` with the necessary components and templates copied over.

When prompted for a project name, use:

```console
myproject
```

Then navigate to your created project:

```bash
cd ./projects/myproject
```

This will create a new folder `projects/myproject` with the default components and scripts inside.

## Step 2: Adding Components to Your Project

MiniTemplate allows you to easily add components to your project using the `run_add.sh` script.

### List Available Components

To list all available components, run the `run_add.sh` script without any arguments inside your project directory:

```bash
./run_add.sh
```

You will see a list of components from `components/default`, `components/custom`, and `components/converted`.

### Add Specific Components

To add a specific component to your project, pass the component name as an argument to `run_add.sh`:

```bash
./run_add.sh button
```

This will copy the `button.html` component into your project directory.

After adding a component, you can embed it in any template or component file using the `{{component_name}}` syntax. For example, to use the button component, add `{{button}}` to your template file.

### Add Default Components

You can also add all default components by running:

```bash
./run_add.sh defaults
```

This command copies all default components (like header, footer, sidebar, etc.) into your project directory.

## Step 3: Converting Source Components

MiniTemplate allows you to transform raw components from `components/source` (which are basic DaisyUI HTML components) into usable MiniTemplate components in `components/converted`.

### Convert Components

Navigate to the `scripts` directory and use the `convert_components.sh` script to convert all raw components:

```bash
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

### Benefits of Conversion

The converted components are self-contained and modular, allowing for easy reuse and consistent styling throughout your project. Each component includes a JavaScript block for additional behavior, making them more powerful compared to the basic DaisyUI HTML.

## Step 4: Generating the Static Site

Once you have all the necessary components in place, you can generate the final `index.html` by running the `run_generate_site.sh` script.

### Generate the Static Site

From your project directory, run:

```bash
./run_generate_site.sh
```

The script processes the main template (`template_default.html`), replacing placeholders (e.g., `{{header_default}}`) with the appropriate component files. The resulting `index.html` can be served directly on any static web host, such as GitHub Pages.

After generating the site, you can manually copy the `index.html` file to the `public` directory:

```bash
cp index.html ../../public/
```

This will allow the static site to be served from the `public` directory if desired.

### Template and Component Nesting

Any template file or component HTML file can include other components using the `{{component}}` syntax. When you run `run_generate_site.sh` from your project folder, these placeholders are replaced by the actual component contents.

## Step 5: Testing the Setup

You can run a suite of tests to ensure that your setup is working as expected.

### Run the Tests

Navigate to the `tests` directory, then run:

```bash
cd ./tests && ./run_tests.sh
```

This will execute the test suite found in the `tests/` directory and validate your project’s setup, components, and templates.

Example output:

```bash
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

Refer to [CONTRIBUTE.md](../CONTRIBUTE.md) for guidelines on how to contribute and see [LICENSE](../LICENSE) for licensing information.

