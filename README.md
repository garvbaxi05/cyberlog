Home Screen UI Implementation Summary
1. Using GridView for Layout

The home screen was built using a two-column GridView, allowing the features to be displayed in an organized, responsive grid layout.
GridView.count(crossAxisCount: 2) was used to ensure the layout remains clean and evenly spaced on all devices.

2. Styling with Container + BoxDecoration

Each card on the home screen was created using a Container widget combined with BoxDecoration to provide:

A unique background color

A smooth borderRadius for rounded corners

Padding and margin for clean spacing

Optional shadow for depth (if applied)

This styling helps each card appear as a distinct clickable feature-button in the UI.

3. Placeholder Data (4 Feature Cards)

The app currently includes four placeholder cards, displayed using the GridView:

Daily Log

Cyber Tips

Device Security

![session5](https://github.com/user-attachments/assets/7d3059da-f276-497a-82e3-d4648f4efd9f)
