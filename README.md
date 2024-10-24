
# ✍️ MiniTemplate - Fast Static Site Generator with CDN

MiniTemplate is a powerful, fast, and CDN-based static site generator designed to help developers build high-performance, modular websites. **No complex setup** or **local dependencies** are required—all you need is an internet connection, and you're ready to build.

This **static site generator** leverages **Tailwind CSS** and **DaisyUI**, making it ideal for anyone who wants to quickly build a site with beautiful, reusable components, without the hassle of manual configuration. If you need a fast, **pagespeed-optimized static site**, MiniTemplate is the perfect choice.

## Why Use MiniTemplate?

- **Blazing Fast**: Optimized for **pagespeed** with CDN-hosted resources.
- **Modular Components**: Easily add UI elements like navigation bars, footers, and more with a few simple commands.
- **Theme-Ready**: Seamlessly integrate popular **DaisyUI themes** to customize the look and feel of your site.
- **No Dependencies**: Forget about local installations like Node.js; everything is served via CDN.

## Quick Start Guide

Ready to build a fast, **SEO-optimized static site**? Here’s how to get started:

### 1. Clone the MiniTemplate Repository

Clone the project to your machine:

```bash
git clone https://github.com/nostack-dev/minitemplate.git
```

### 2. Create Your Project

Use the provided script to create a new project. You can specify a **project name** and select a theme from DaisyUI to match your design.

```bash
./run_create_project.sh [project_name] [theme]
```

- `[project_name]`: Your desired project name.
- `[theme]` (optional): Pick a theme (e.g., **cyberpunk**, **dark**, **light**, **business**). Explore more themes on the [DaisyUI theme page](https://daisyui.com/docs/themes/).

Example:

```bash
./run_create_project.sh my-awesome-site dark
```

This will set up your project with the chosen theme and ensure **fast loading speeds** via CDN resources.

### 3. Add Components

To add pre-built, **pagespeed-optimized components** (such as a navigation bar or footer), navigate to your project directory:

```bash
cd ./projects/my-awesome-site
```

Then run the following command to add components from **DaisyUI**:

```bash
./run_add.sh [component_name] 
```

- `[component_name]`: Name of the component (e.g., **navbar**, **footer**).

Example:

```bash
./run_add.sh navbar
```

### 4. Generate the Site

After adding components, generate the static HTML files using:

```bash
./run_generate.sh
```

This will create or update the `index.html` file, with all components integrated.

### 5. Print the Site Structure

For a quick overview of your site structure, use the print command:

```bash
./print.sh
```

### 6. Test Your Setup

To ensure everything is functioning properly, run the test scripts:

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

Run these tests to validate that all components, templates, and scripts are working as intended.

## Example Pre-Created Project Structure

MiniTemplate comes with an **example project** that shows how the components and structure can be used. Here's the structure:

```
projects/example
├── index.html          # The main entry point for the static site
├── run_add.sh          # Script to add components
├── run_generate.sh     # Script to generate the site
├── print.sh            # Script to print the site structure
└── components
    ├── navbar.html     # Pre-built navbar component
    ├── footer.html     # Pre-built footer component
    └── content.html    # Pre-built content area component
```

Feel free to explore and modify this example to suit your needs.

## Components and Themes

MiniTemplate includes a collection of reusable, **SEO-friendly components** from **DaisyUI**, such as:

- **Buttons**
- **Forms**
- **Modals**
- **Navigation bars**
- **Footers**
- **Tables**

Explore the full range of available components [here](https://daisyui.com/components/).

Additionally, MiniTemplate supports DaisyUI's **theme system**, allowing you to quickly switch between designs. Check out the full theme reference [here](https://daisyui.com/docs/themes/).

## Pagespeed Optimization & SEO Benefits

With **CDN-hosted** resources, MiniTemplate is designed for **pagespeed optimization**. A fast website means better user experience and higher rankings on search engines like Google. The SEO-friendly architecture makes it easier for your static site to perform well, even in highly competitive search environments.

## No Local Dependencies

There’s no need for local tools like Node.js. MiniTemplate runs entirely on CDN resources, making it the **simplest static site generator** for building quick and efficient websites.

## Contribute

We welcome contributions from the community! If you’d like to contribute, please check the [CONTRIBUTING.md](./CONTRIBUTING.md) file for details on how to get started.

## License

This project is licensed under the MIT License. See the [LICENSE](./LICENSE) file for more information.

---

With **MiniTemplate**, you can create high-performance, modular websites that are optimized for **speed** and **SEO**. Whether you're building a personal site, a professional portfolio, or a business page, MiniTemplate gives you the tools to create a fast, responsive website.
