
# ✍️ MiniTemplate - Simple Template Engine

This guide will walk you through setting up a MiniTemplate project, converting components, adding templates, and finally generating a static `index.html` file. We will break the setup into two parts, with a focus on ease of use and integration.

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
└── tests                # Test scripts to validate MiniTemplate functionality
```

## Step 1: Setting Up Your Project

### 1. Clone the repository

```bash
git clone https://github.com/nostack-dev/minitemplate.git
cd minitemplate
```

Ensure all the files and directories listed in the directory structure are present before proceeding.

### 2. Run `create_project.sh`

This script will create a new project directory with default components and templates.

```bash
./scripts/create_project.sh
```

You will be prompted to provide a name for your project. Once done, the script will generate a new project directory under `projects/` with the necessary components and templates copied over.

Example:

```bash
Enter the project name: myproject
```

This will create a new folder `projects/myproject` with the default components and scripts inside.

# ✍️ MiniTemplate - Simple Template Engine - Part 2

## Step 2: Adding Components to Your Project

MiniTemplate allows you to easily add components to your project using the `add.sh` script.

### List Available Components

To list all available components, run the `add.sh` script without any arguments:

```bash
./scripts/add.sh
```

You will see a list of components from `components/default`, `components/custom`, and `components/converted`.

### Add Specific Components

To add a specific component to your project, pass the component name as an argument to `add.sh`:

```bash
./scripts/add.sh button
```

This will copy the `button.html` component into your project directory.

### Add Default Components

You can also add all default components by running:

```bash
./scripts/add.sh defaults
```

This command copies all default components (like header, footer, sidebar, etc.) into your project directory.

## Step 3: Converting Source Components

MiniTemplate allows you to transform raw components from `components/source` into usable components in `components/converted`.

### Convert Components

Use the `convert_components.sh` script to convert all raw components:

```bash
./scripts/convert_components.sh
```

This will read all HTML files in the `source` directory and convert them into self-contained components, which will be placed in the `converted` directory.

## Step 4: Generating the Static Site

Once you have all the necessary components in place, you can generate the final `index.html` by running the `generate_site.sh` script.

### Generate the Static Site

```bash
./scripts/generate_site.sh
```

The script reads the main template (`template_default.html`) and replaces placeholders (like `{{header_default}}`) with the corresponding component files. The generated `index.html` file will be saved in the root of your project or the `public` directory.
