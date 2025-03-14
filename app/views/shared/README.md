# Shared Authorization UI Components

This directory contains reusable UI components that respect user permissions based on Pundit policies.

## Available Components

### 1. Action Buttons (`_action_buttons.html.erb`)

Renders view, edit, and delete buttons based on user permissions.

**Usage:**
```erb
<%= render 'shared/action_buttons', resource: @resource %>
```

**Parameters:**
- `resource`: The resource to check permissions against

**Note:** The partial checks if the resource is defined before rendering any buttons, so it's safe to use even if the resource might be nil.

### 2. New Resource Button (`_new_resource_button.html.erb`)

Renders a "New Resource" button based on user permissions.

**Usage:**
```erb
<%= render 'shared/new_resource_button', 
           resource_class: Resource, 
           path: new_resource_path, 
           button_text: "New resource" %>
```

**Parameters:**
- `resource_class`: The class of the resource to check permissions against
- `path`: The path to the new resource form
- `button_text`: The text to display on the button

**Note:** The partial checks if the resource_class is defined before rendering the button, so it's safe to use even if the resource_class might be nil.

### 3. Show Actions (`_show_actions.html.erb`)

Renders action buttons (edit, delete) for show pages based on user permissions.

**Usage:**
```erb
<%= render 'shared/show_actions', resource: @resource %>
```

With custom actions:
```erb
<%= render 'shared/show_actions', resource: @resource, custom_actions: capture do %>
  <% if policy(@resource).some_custom_action? %>
    <%= link_to custom_action_path(@resource), class: "button-class" do %>
      Custom Action
    <% end %>
  <% end %>
<% end %>
```

**Parameters:**
- `resource`: The resource to check permissions against
- `custom_actions`: (Optional) Additional custom action buttons

**Note:** The partial checks if the resource is defined before rendering any buttons, so it's safe to use even if the resource might be nil.

## Implementation Example

### Index View

```erb
<% content_for :title, "Resources" %>

<div class="container">
  <div class="header">
    <div class="title">
      <h1>Resources</h1>
      <p>A list of all resources in the system.</p>
    </div>
    <%= render 'shared/new_resource_button', 
               resource_class: Resource, 
               path: new_resource_path, 
               button_text: "New resource" %>
  </div>

  <table>
    <thead>
      <tr>
        <th>Name</th>
        <th>Actions</th>
      </tr>
    </thead>
    <tbody>
      <% @resources.each do |resource| %>
        <tr>
          <td><%= resource.name %></td>
          <td>
            <%= render 'shared/action_buttons', resource: resource %>
          </td>
        </tr>
      <% end %>
    </tbody>
  </table>
</div>
```

### Show View

```erb
<% content_for :title, "Resource Details" %>

<div class="container">
  <div class="header">
    <h1><%= @resource.name %></h1>
  </div>

  <div class="details">
    <!-- Resource details here -->
  </div>

  <%= render 'shared/show_actions', resource: @resource %>
</div>
``` 