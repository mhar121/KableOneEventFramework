import xml.etree.ElementTree as ET

tree = ET.parse('KableOneEventsFramework/Controllers/EventsDetailsViewController.xib')
root = tree.getroot()

# Find the main view
objects = root.find('objects')
main_view = objects.find("view[@id='i5M-Pr-FkT']")
subviews = main_view.find('subviews')

# Find image view and detail view
image_view = subviews.find("imageView[@id='bp5-qF-i7i']")
detail_view = subviews.find("view[@id='mMK-jD-ol5']")

# Remove them from main view's subviews
subviews.remove(image_view)
subviews.remove(detail_view)

# Create Scroll View
scroll_view = ET.Element('scrollView', {
    'clipsSubviews': 'YES',
    'multipleTouchEnabled': 'YES',
    'contentMode': 'scaleToFill',
    'showsHorizontalScrollIndicator': 'NO',
    'showsVerticalScrollIndicator': 'NO',
    'translatesAutoresizingMaskIntoConstraints': 'NO',
    'id': 'SCR-ol-Vie'
})

scroll_subviews = ET.SubElement(scroll_view, 'subviews')

# Create Content View
content_view = ET.Element('view', {
    'contentMode': 'scaleToFill',
    'translatesAutoresizingMaskIntoConstraints': 'NO',
    'id': 'CON-te-NTV'
})
content_subviews = ET.SubElement(content_view, 'subviews')

# Add image and detail to content view
content_subviews.append(image_view)
content_subviews.append(detail_view)

# Add content view to scroll view
scroll_subviews.append(content_view)

# Insert scroll view before the back button
# Assuming fmO-EM-tCP is the back button
back_button = subviews.find("button[@id='fmO-EM-tCP']")
subviews.remove(back_button)
subviews.append(scroll_view)
subviews.append(back_button)

# Fix Constraints
main_constraints = main_view.find('constraints')

# We need to keep:
# back button constraints: hpC-ik-L7t, 2oP-rm-kcd
# uq1-yg-3ec constraint: hBm-Zk-98M (Wait, this constraint uses fnl-2z-Ty3 which is main view's safe area. This constraint centers uq1-yg-3ec horizontally relative to main view's safe area. If we put detail_view in scroll_view, this might still work or might break since it's crossing hierarchy. Actually it is valid to cross hierarchy, but better to fix it to center relative to detail_view itself. Wait, detail_view is mMK-jD-ol5.)

# Let's see all constraints
to_keep = []
to_move_to_content_view = []

for c in list(main_constraints):
    c_id = c.get('id')
    firstItem = c.get('firstItem')
    secondItem = c.get('secondItem')
    
    if firstItem == 'fmO-EM-tCP' or secondItem == 'fmO-EM-tCP':
        to_keep.append(c)
    elif c_id == 'hBm-Zk-98M':
        # Change secondItem from fnl-2z-Ty3 to mMK-jD-ol5
        c.set('secondItem', 'mMK-jD-ol5')
        to_move_to_content_view.append(c)
    elif firstItem == 'fnl-2z-Ty3' or secondItem == 'fnl-2z-Ty3':
        # Replace fnl-2z-Ty3 (safe area) with CON-te-NTV
        if firstItem == 'fnl-2z-Ty3': c.set('firstItem', 'CON-te-NTV')
        if secondItem == 'fnl-2z-Ty3': c.set('secondItem', 'CON-te-NTV')
        to_move_to_content_view.append(c)
    else:
        to_move_to_content_view.append(c)

# Clear main constraints and put back what we kept
for c in list(main_constraints):
    main_constraints.remove(c)
    
for c in to_keep:
    main_constraints.append(c)

# Add constraints for ScrollView to main view
main_constraints.append(ET.Element('constraint', {'firstItem': 'SCR-ol-Vie', 'firstAttribute': 'top', 'secondItem': 'fnl-2z-Ty3', 'secondAttribute': 'top', 'id': 'scr-top'}))
main_constraints.append(ET.Element('constraint', {'firstItem': 'SCR-ol-Vie', 'firstAttribute': 'leading', 'secondItem': 'fnl-2z-Ty3', 'secondAttribute': 'leading', 'id': 'scr-lead'}))
main_constraints.append(ET.Element('constraint', {'firstItem': 'fnl-2z-Ty3', 'firstAttribute': 'trailing', 'secondItem': 'SCR-ol-Vie', 'secondAttribute': 'trailing', 'id': 'scr-trail'}))
main_constraints.append(ET.Element('constraint', {'firstAttribute': 'bottom', 'secondItem': 'SCR-ol-Vie', 'secondAttribute': 'bottom', 'id': 'scr-bot'}))

# Add constraints for ContentView inside ScrollView
scroll_constraints = ET.SubElement(scroll_view, 'constraints')

scroll_constraints.append(ET.Element('constraint', {'firstItem': 'CON-te-NTV', 'firstAttribute': 'top', 'secondItem': 'SCR-ol-Vie', 'secondAttribute': 'top', 'id': 'cv-top'}))
scroll_constraints.append(ET.Element('constraint', {'firstItem': 'CON-te-NTV', 'firstAttribute': 'leading', 'secondItem': 'SCR-ol-Vie', 'secondAttribute': 'leading', 'id': 'cv-lead'}))
scroll_constraints.append(ET.Element('constraint', {'firstAttribute': 'trailing', 'secondItem': 'CON-te-NTV', 'secondAttribute': 'trailing', 'id': 'cv-trail'}))
scroll_constraints.append(ET.Element('constraint', {'firstAttribute': 'bottom', 'secondItem': 'CON-te-NTV', 'secondAttribute': 'bottom', 'id': 'cv-bot'}))

# Make ContentView width equal to ScrollView width
scroll_constraints.append(ET.Element('constraint', {'firstItem': 'CON-te-NTV', 'firstAttribute': 'width', 'secondItem': 'SCR-ol-Vie', 'secondAttribute': 'width', 'id': 'cv-width'}))

# Add moved constraints to content_view
cv_constraints = ET.SubElement(content_view, 'constraints')
for c in to_move_to_content_view:
    cv_constraints.append(c)

# Save
tree.write('KableOneEventsFramework/Controllers/EventsDetailsViewController.xib', encoding='UTF-8', xml_declaration=True)
