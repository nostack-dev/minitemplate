
# ✍️ MiniTemplate - Build Static Websites Effortlessly

MiniTemplate is a powerful, easy-to-use, self-contained template engine that helps developers build modular, consistent web applications—**without** any dependency hell or complex setup. All you need is an internet connection and a few scripts to get started. MiniTemplate leverages CDN-hosted resources like **Tailwind CSS** and **DaisyUI**, ensuring that your project stays lightweight, fast, and scalable.

## Why Use MiniTemplate?

- **CDN-Based**: No need for local installs like Node.js; everything runs through the browser.
- **Modular Components**: Add UI elements (e.g., buttons, navigation bars) with minimal effort.
- **Theme-Ready**: Easily apply beautiful, ready-to-use themes from **DaisyUI**.
- **Automation Scripts**: Set up and manage your project quickly with helpful scripts.

## Quick Start Guide

Ready to build a website in minutes? Follow these steps to get started:

### 1. Clone the MiniTemplate Repository

Clone the project to your machine:

```bash
git clone https://github.com/nostack-dev/minitemplate.git
```

### 2. Create Your Project

Use the provided script to create a new project. You can specify a **project name** and select a theme from DaisyUI.

```bash
./run_create_project.sh [project_name] [theme]
```

- `[project_name]`: Your desired project name.
- `[theme]` (optional): Pick a theme (e.g., **cyberpunk**, **dark**, **light**, **business**). Find more themes on the [DaisyUI theme page](https://daisyui.com/docs/themes/).

Example:

```bash
./run_create_project.sh my-awesome-site dark
```

This creates a new project directory with the chosen theme applied.

### 3. Add Components

To add pre-built components (like a navigation bar, footer, etc.), first navigate to the project directory you just created:

```bash
cd my-awesome-site
```

Then, run the following script to include the component:

```bash
../run_add.sh [component_name] [project_name]
```

- `[component_name]`: The name of the UI component (e.g., **navbar**, **footer**).
- `[project_name]`: Your project directory.

Example:

```bash
../run_add.sh navbar my-awesome-site
```

### 4. Customize Your Project

After the project is created, you can modify any component or template. Simply open the project directory, edit the files, and see your changes instantly.

### 5. Test Your Setup

Make sure everything is working as expected by running the test scripts:

```bash
bash run_tests.sh
```

#### Example Output

```
✔ Test passed: run_create_project.sh ran successfully.
✔ Component 'navbar' added to 'my-awesome-site'.
✔ Template generation test passed: 'index.html' created with the selected theme.
✔ All tests passed successfully.
```

You can add new tests or review the existing ones to ensure your project’s integrity. The test suite will validate that all your components, templates, and scripts are correctly integrated.

## Components and Themes

MiniTemplate comes with a variety of pre-converted, reusable **DaisyUI components** such as:

- **Buttons**
- **Forms**
- **Modals**
- **Navigation bars**
- **Footers**
- **Tables**

You can view and explore all available components [here](https://daisyui.com/components/).

Additionally, MiniTemplate supports DaisyUI's extensive **theme system**, which allows you to apply different looks to your site with minimal effort. Check out the full theme reference [here](https://daisyui.com/docs/themes/) to pick the one that fits your project.

## No Local Dependencies

Forget about installing local dependencies like Node.js. MiniTemplate is fully CDN-powered, so all you need is an internet connection. The included scripts are simple Bash scripts to automate project creation and component integration.

## Contribute

We welcome contributions from the community! If you’d like to contribute, please check the [CONTRIBUTING.md](./CONTRIBUTING.md) file for details on how to get started.

## License

This project is licensed under the MIT License. See the [LICENSE](./LICENSE) file for more information.

---

With **MiniTemplate**, you can build efficient, modular, and reusable web applications. Whether you're developing a personal site, a blog, or a professional project, MiniTemplate has the flexibility and tools to help you create a modern, responsive website with ease.
