# Authorization System Documentation

This document provides an overview of the authorization system implemented in the application.

## Overview

The application uses Pundit for authorization, which is based on policy objects. Each resource in the application has a corresponding policy that defines what actions different users can perform on that resource.

## User Roles

The application has three main user roles:

1. **Dean**: Has full access to all resources and can manage all aspects of the application.
2. **Teacher**: Can manage courses they teach, view and manage grades for their students, and view school classes.
3. **Student**: Can view their own grades, courses, and school classes.

## Policy Structure

Each policy follows a similar structure:

```ruby
class ResourcePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.dean?
        scope.all
      elsif user.teacher?
        # Scope to resources relevant to the teacher
      elsif user.student?
        # Scope to resources relevant to the student
      else
        scope.none
      end
    end
  end

  def index?
    true  # Usually accessible to all authenticated users
  end

  def show?
    # Logic to determine if user can view the resource
  end

  def create?
    user.dean?  # Usually only deans can create resources
  end

  def update?
    user.dean?  # Usually only deans can update resources
  end

  def destroy?
    user.dean?  # Usually only deans can delete resources
  end
end
```

## Controller Integration

All controllers have been updated to use the policies for authorization. This is done using the following methods:

1. `authorize Resource` or `authorize @resource` to check if the user can perform the current action.
2. `policy_scope(Resource)` to scope the resources based on the user's permissions.

Example:

```ruby
def index
  @resources = policy_scope(Resource)
  authorize Resource
end

def show
  authorize @resource
end
```

### Special Cases

1. **First User Creation**: The application has a special case for the first user creation:
   ```ruby
   def first_user_creation?
     Person.count.zero? && 
       controller_name == 'people' && 
       ['new', 'create'].include?(action_name)
   end
   ```
   This allows the creation of the first user (who becomes a dean) without requiring authentication.

2. **Soft Delete Integration**: The application includes the `SoftDeleteController` module which provides functionality for managing soft-deleted records. The `DeletedObjectsPolicy` controls access to this functionality:
   ```ruby
   class DeletedObjectsPolicy < ApplicationPolicy
     def index?
       dean?
     end

     def restore?
       dean?
     end
   end
   ```

## View Integration

Views have been updated to hide actions that users don't have permission to perform. This is done using shared partials:

1. `_action_buttons.html.erb`: Renders view, edit, and delete buttons based on user permissions.
2. `_new_resource_button.html.erb`: Renders a "New Resource" button based on user permissions.
3. `_show_actions.html.erb`: Renders action buttons for show pages based on user permissions.

All of these partials include checks to ensure they only render content when the resource or resource class is defined, and the user has the appropriate permissions. This prevents errors and ensures that buttons are not displayed to users who don't have permission to use them.

### Conditional Rendering in Views

To ensure that UI elements are only displayed to users with the appropriate permissions, we've implemented conditional rendering in all views:

1. **Table Headers**: Action column headers are only displayed if the user has permission to perform actions on at least one resource:
   ```erb
   <% if policy(Resource).edit? || policy(Resource).destroy? %>
     <th scope="col" class="relative py-3.5 pl-3 pr-4 sm:pr-6">
       <span class="sr-only">Actions</span>
     </th>
   <% end %>
   ```

2. **Table Cells**: Action cells are only displayed if the user has permission to perform actions on the specific resource:
   ```erb
   <% if policy(resource).edit? || policy(resource).destroy? %>
     <td class="relative whitespace-nowrap py-4 pl-3 pr-4 text-right text-sm font-medium sm:pr-6">
       <%= render 'shared/action_buttons', resource: resource %>
     </td>
   <% end %>
   ```

3. **Action Buttons Partial**: The action buttons partial itself checks if any buttons should be displayed:
   ```erb
   <% has_buttons = policy(resource).edit? || policy(resource).destroy? %>
   <% if has_buttons %>
     <!-- Button content -->
   <% end %>
   ```

4. **Show Actions Partial**: The show actions partial checks if any buttons or custom actions should be displayed:
   ```erb
   <% has_buttons = policy(resource).edit? || policy(resource).destroy? || defined?(custom_actions) %>
   <% if has_buttons %>
     <!-- Button content -->
   <% end %>
   ```

5. **New Resource Button**: The new resource button is only displayed if the user has permission to create the resource:
   ```erb
   <% if policy(resource_class).create? %>
     <%= render 'shared/new_resource_button', resource_class: Resource, path: new_resource_path, button_text: "New resource" %>
   <% end %>
   ```

## Special Permissions

Some resources have special permissions beyond the standard CRUD operations:

1. **Person Management**:
   - `manage_role?`: Controls who can change user roles (only deans)
   - Special handling for self-updates (users can update their own profiles but can't change their role)

2. **Report Generation**:
   - `export_pdf?`: Controls who can export PDF reports
   - Students can export their own reports
   - Deans can export any student's report

3. **Student Management**:
   - `manage_students?`: Controls who can manage student enrollments in classes
   - `update_students?`: Controls who can update student enrollments

These conditional checks ensure that UI elements are only displayed to users who have the appropriate permissions, enhancing both security and user experience.

## Testing Authorization

To test the authorization system, you can:

1. Log in as different users with different roles.
2. Try to access different resources and perform different actions.
3. Verify that the appropriate actions are available or hidden based on the user's role.

## Adding New Resources

When adding a new resource to the application:

1. Create a policy for the resource in `app/policies`.
2. Update the controller to use the policy.
3. Update the views to use the shared partials for action buttons.
4. Ensure proper conditional rendering in the views based on user permissions.

## Troubleshooting

If you encounter authorization issues:

1. Check the policy to ensure the correct permissions are defined.
2. Check the controller to ensure the `authorize` and `policy_scope` methods are called.
3. Check the views to ensure the correct policy checks are used.
4. Check the user's role to ensure they have the correct permissions.
5. Ensure that the resource or resource class is properly defined before checking permissions.
6. Verify that conditional rendering is implemented correctly in all views.

## Conclusion

The authorization system ensures that users can only perform actions they are authorized to perform, enhancing the security and usability of the application. The combination of Pundit policies and conditional rendering in views provides a robust and user-friendly authorization system. 