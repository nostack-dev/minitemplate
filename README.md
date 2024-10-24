
# ✍️ MiniTemplate - Static CDN-Only Template Engine

MiniTemplate is a lightweight, self-contained template engine designed for static web applications. It allows developers to efficiently reuse components and maintain design consistency without the need for complex setups. All assets are served via CDN, making it a dependency-free solution.

## Project Structure

The project is organized with the following structure:

```
/components        # Reusable UI components
/scripts           # Automation scripts for project workflows
/templates         # HTML templates
/tests             # Test scripts to validate functionality
```

## Scripts Overview

### `run_create_project.sh`

This script sets up a new project by generating all necessary folders and files based on a chosen template.

**Parameters:**

- `[project_name]`: The name of your new project.
- `[template]` (optional): Template to base your project on (default, blog, ecommerce).

**Usage Example:**

```bash
./run_create_project.sh my-app [default]
```

### `run_add.sh`

This script dynamically adds UI components to your project.

**Parameters:**

- `[component]`: Name of the component to be added (e.g., `navbar`, `footer`).
- `[project]`: The project directory where the component will be placed.

**Usage Example:**

```bash
./run_add.sh navbar my-app
```

## Testing and Quality Assurance

All tests reside in the `/tests` directory and validate the proper integration of components, script functionality, and the output of templates.

### Running Tests

To run tests, navigate to the `tests` directory and execute:

```bash
bash run_tests.sh
```

## Workflow Overview

1. **Project Initialization**: Set up a new project using `run_create_project.sh`.
2. **Component Addition**: Add new components to the project using `run_add.sh`.
3. **Customization**: Adjust the components and templates according to your needs.
4. **Testing**: Run the test suite to ensure everything works as expected.

## Dependencies

MiniTemplate uses CDN-hosted resources, so no local installations are required.

- **Tailwind CSS** (via CDN)
- **DaisyUI** (via CDN)
- **Bash** (for script execution)

## Getting Started

1. Clone the repository to your machine:

```bash
git clone https://github.com/nostack-dev/minitemplate.git
```

2. Use the provided scripts to quickly set up your project.

---

With **MiniTemplate**, you can build efficient, modular, and reusable web applications. Feel free to customize components and templates as needed.
