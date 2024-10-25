
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
git clone https://github.com/nostack-dev/minitemplate.git && cd minitemplate
```

### 2. Create Your Project

Use the provided script to create a new project. You can specify a **project name** and select a theme from DaisyUI to match your design.

Create your Project:

```bash
./run_create_project.sh my-awesome-site dark
```
This will set up your project with the chosen theme and ensure **fast loading speeds** via CDN resources.

Additional Parameters:
- `[project_name]`: Your desired project name.
- `[theme]` (optional): Pick a theme (e.g., **cyberpunk**, **dark**, **light**, **business**). Explore more themes on the [DaisyUI theme page](https://daisyui.com/docs/themes/).

### 3. Serve Your Site for Development

First, navigate to your project directory:

```bash
cd ./projects/my-awesome-site
```

Then, to start the development server and preview your project, run:

```bash
./run_serve.sh
```

You can now visit your site at [http://localhost:8000](http://localhost:8000) to view the served index.html.

### 4. Add a Component

To customize your site, you can add components. Let’s add a button component to your project:

```bash
./run_add.sh button
```

This command will generate a new `button.html` file in your project’s components folder. Now, you can use this component inside your template.

### 5. Insert the Component in the Template

Open the `template_default.html` file located in your project’s templates folder. To include the newly added button component, find a suitable place within the template and add the following placeholder:

```html
{{button}}
```

Example: Open your `template_default.html` and add your component:

```bash
nano ./template_default.html
```

Find a place to insert `{{button}}` in the template below:

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Site</title>

    <!-- Tailwind and DaisyUI -->
    <link href="https://cdn.jsdelivr.net/npm/daisyui@4.12.12/dist/full.min.css" rel="stylesheet" />
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="flex flex-col min-h-screen" data-theme="">

    <div id="sidebar">
        {{sidebar_default}}
    </div>

    <div class="my-4 flex items-center justify-center">
        <!--Replace this line with your component, for example: --> {{button}}
    </div>

    <div id="content" class="flex-1 p-6">
        {{content_default}}
    </div>

    <footer class="p-4">
        {{footer_default}}
    </footer>

</body>
</html>
```

### 6. Re-generate the Site

After adding the component and saving the template, you need to re-create the index.html file to reflect your changes:

```bash
./run_generate.sh
```

This will regenerate the `index.html` file with the newly integrated button component.

### 7. Serve the index.html

Run this command to serve the new index.html:

```bash
./run_serve.sh
```

Open your browser on http://localhost:8000 to view your new site and your added component.

## Example Pre-Created Project Structure

MiniTemplate comes with an **example project** that shows how the components and structure can be used. Here's the structure:

```
projects/example
├── content_default.html           # Default content component
├── footer_default.html            # Default footer component
├── header_default.html            # Default header component
├── hero_default.html              # Default hero component
├── index.html                     # Default footer component
├── print.sh                       # Script to print the site structure
├── run_add.sh                     # Script to add components
├── run_generate.sh                # Script to generate the site
├── run_serve.sh                   # Script to serve the index.html locally
├── sidebar_default.html           # Default sidebar component
├── template_default.html          # Default template file
└── themecontroller_default.html   # Default themecontroller component
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

## Production Optimization

To further optimize your MiniTemplate project for production, you can follow these simple steps to ensure minimal file sizes and faster page load times without using any npm or local dependencies:

1. **Use PurgeCSS via CDN**: PurgeCSS can help remove any unused CSS classes from Tailwind and DaisyUI, reducing the final CSS file size significantly.
   - Add this `<script>` tag to your HTML:
     ```html
     <script src="https://unpkg.com/purgecss@2.1.0/lib/browser.js"></script>
     ```
   - PurgeCSS will automatically analyze your HTML for used CSS classes and purge unused ones on the fly.

2. **Enable Tailwind CSS JIT Mode**: When loading Tailwind via CDN, use the Just-In-Time (JIT) mode to keep your styles optimized during development.
   - Use this `<script>` tag in your HTML:
     ```html
     <script src="https://cdn.tailwindcss.com?plugins=forms,typography,aspect-ratio"></script>
     <script>
         tailwind.config = {
             mode: 'jit',
             purge: ['./**/*.html'],
         }
     </script>
     ```
   - This helps ensure only the required classes are included.

By using PurgeCSS and enabling Tailwind JIT mode directly from the CDN, you can significantly reduce your CSS file size and boost your site's performance without needing any additional tools or setups.

## Running Tests

MiniTemplate provides built-in test scripts to verify the integrity and functionality of your site. Running the following command will initiate the test suite:

Navigate to the root of the repository and run:
```bash
cd  tests && run_tests.sh
```

#### Example Output

```
✔ Test passed: run_create_project.sh ran successfully.
✔ Component 'navbar' added to 'my-awesome-site'.
✔ Template generation test passed: 'index.html' created with the selected theme.
✔ All tests passed successfully.
```


## Additional information: MiniTemplate-Components structure:

MiniTemplate’s components are modular, with **auto-generated IDs**, **scoped CSS**, and **collision-free JavaScript**. Here’s an example of how a component is structured, showcasing the best practices for performance and maintainability:

```html
<div id="button_default" class="btn" aria-label="Button Component">
    Click Me
    <script>
        // local state
        (() => {
            let clicked = false;
            document.getElementById('button_default').addEventListener('click', () => {
                clicked = !clicked;
                console.log('Button clicked:', clicked);
            });
        })();
    </script>
</div>
```

### Benefits:
- **Auto-generated IDs** prevent conflicts.
- **Scoped CSS** ensures that styles don't leak into other components.
- **Collision-free JavaScript** using an Immediately Invoked Function Expression (IIFE) for encapsulation.
- **Embedded Script** for optional state management, adding flexibility.

## Contribute

We welcome contributions from the community! If you’d like to contribute, please check the [CONTRIBUTING.md](./CONTRIBUTING.md) file for details on how to get started.

## License

This project is licensed under the MIT License. See the [LICENSE](./LICENSE) file for more information.

---

With **MiniTemplate**, you can create high-performance, modular websites that are optimized for **speed** and **SEO**. Whether you're building a personal site, a professional portfolio, or a business page, MiniTemplate gives you the tools to create a fast, responsive website.
