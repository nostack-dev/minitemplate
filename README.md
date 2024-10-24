
# MiniTemplate

MiniTemplate is a lightweight, efficient template engine tailored for static web applications. It simplifies component reuse and ensures design consistency across projects. MiniTemplate seamlessly integrates with Tailwind CSS and DaisyUI to accelerate UI development.

## Project Structure

The project follows a simple, organized folder structure:

```
/components        # Reusable UI components
/scripts           # Automation scripts for managing project workflows
/templates         # Core HTML templates for project scaffolding
/tests             # Automated tests to verify components and scripts
```

## Scripts Overview

### `run_create_project.sh`

This script streamlines the creation of new projects by generating the necessary folders and files based on a predefined template. You can specify various parameters to customize the setup.

**Parameters:**
- `--project-name`: The name of your new project.
- `--template`: Choose a template to base your project on (e.g., `default`, `blog`, `ecommerce`).

**Usage Example:**

```bash
./scripts/run_create_project.sh --project-name my-awesome-app --template ecommerce
```

### `run_add.sh`

Use this script to add new components (like UI elements) into your project dynamically.

**Parameters:**
- `--component`: The name of the component to be added (e.g., `navbar`, `footer`).
- `--project`: The project directory where the component will be placed.

**Usage Example:**

```bash
./scripts/run_add.sh --component navbar --project my-awesome-app
```

## Testing and Quality Assurance

The `/tests` directory contains automated tests designed to ensure that all project components and scripts function as expected. These tests validate everything from component integration to script execution.

### Running Tests

To run the entire suite of tests, simply navigate to the `tests` directory and execute:

```bash
bash run_tests.sh
```

## Workflow Overview

1. **Project Initialization**: Create a new project with `run_create_project.sh`.
2. **Component Addition**: Dynamically add components using `run_add.sh`.
3. **Customization**: Adjust your components or templates to fit your needs.
4. **Testing**: Run the tests to verify that everything works as intended.

## Dependencies

To ensure smooth operation, the following dependencies must be installed:

- **Node.js**: Required for managing frontend libraries like Tailwind CSS and DaisyUI.
- **Tailwind CSS**: For styling components and templates.
- **DaisyUI**: For pre-built UI components.
- **Bash**: Used to execute the provided shell scripts.

## Getting Started

1. Clone the repository to your local machine:

```bash
git clone https://github.com/nostack-dev/minitemplate.git
```

2. Install any necessary dependencies by following the instructions in the `scripts` folder.
3. Use the provided scripts to quickly set up and manage your project.

---

Enjoy building scalable and reusable web applications with **MiniTemplate**. Feel free to customize components and templates to fit your specific needs.

