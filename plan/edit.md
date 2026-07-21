**Goal:** I am vibe coding, developing a high quality mobile application, a habit tracking app that will be built using flutter/dart, the core principle around which it will be built: "make it easy, make it visible, make it satisfying, make it attractive" for the user using it. Create the screen I am describing here in text and in image.

**Full-Screen Background:** The entire screen is set against a dynamic, fixed, full-screen fixed-position background layer. This layer features a soft, luminous, flowing WebGL shader effect, described as a 'shifting light nebula' with cool blues and hints of purple (referenced as `{{DATA:ANIMATION:ANIMATION_29}}`).

**Main UI Container (Glassmorphism):** All habit cards feature subtle glassmorphism, with a smooth backdrop-blur and soft frosted-edge texture that allows the colorful background nebula to show through. The cards have a clean, minimalist layout with premium text rendering.

**Header Section (As seen in Home_screen.png):**

- At the top-left, the clean text `17 Apr` is displayed. (which will be the current date)
- Next to it, a subtle, dark pill-shaped badge contains the specific text `1/3 HAB` (which changes with how many habits for the day were completed).
- At the top-right, aligned with the date, is a subtle '+' (add) icon, followed by a gear (settings) icon. (These will lead to new screens or pop them up on current screen for adding a new habit or altering app's settings)

**Vertical Habit Card List (Main Content):** A stack of glassmorphic cards fills the screen body.

**Card 1 (A measurable type habit where user is supposed to enter a value):**

- This is a large, clickable/tappable card, shown in its expanded state.
- **Header:** "Morning Run" (text), "5 km" (text).
- **Action Button:** A light-blue "Ent" (Entry) button is on the far right.
- **Carousel View:** The card contains an internal horizontal carousel, which is currently on its first page. This page displays the full habit completion heatmap calendar for the latest three months including the current one, with the last square on the right side denoting the present day (`FEB`, `MAR`, `APR` headings are there as an example of concept), with a dense grid of varying shades of blue/grey cells (specific to `Home_screen.png`, if the target was achieved on a specific day , the square will be a shade of blue (greater the intensity, more the value), if the target was not achieved the colour will vary from black to shades of gray with more intensity).
- **Pagination Dots:** Directly below the heatmap are three clean pagination dots, with the first dot fully lit to indicate the active page.

**Card 2 (a checkmark type habit, where the user simply has to click the box in the habit container to mark whether a particular habit was done or not):**

- A second clickable glassmorphic card below the first. (it will also expand upon being clicked)
- **Header:** "Meditation" (text), "10 mins daily" (text).
- **Interaction/Completion Effect:** The central action button is depicted _mid-interaction_. From the dark pink-outlined 'X' (incomplete) button, a satisfying, radiating burst of particles is exploding outward in an illustrative, glowing particle-burst effect (as if JavaScript triggered). The 'X' is still visible at the core of the explosion, but a translucent, translucent, emerging 'V' (complete) symbol is overlaying it, showing the transition.

**Entrance & Texture:** Subtle grain texture on the dark interface. The general view implies the scene has just loaded, with the cards showing the final step of a staggered fade-in and slide-up animation. Subtle lighting from the background illuminates the card edges.

**"satisfying habit-completion" toggle button with a particle-burst + sound effect.**

A circular/rounded-square toggle button that represents a habit's done state. It has two states:

- **Incomplete:** a red/destructive-tinted outline with an `X` icon inside.
- **Complete:** a blue/primary-tinted outline with a glowing check (`✓`) icon and a soft outer glow (box-shadow).

**Icon morph:** On press, cross-fade the `X` out and the check in — the outgoing icon scales down from 1.0 → 0.5 while fading to 0 opacity, and the incoming icon scales up from 0.5 → 1.0 while fading to full opacity, both over ~300ms. Add a quick `active:scale-90` press-down feedback.

**Particle burst (only when marking complete):** Render a transient overlay centered on the button for ~700ms containing:

- A single **glow ring**: a thin primary-colored circular border that starts small and fully opaque, then expands (~scale 1 → 2) while fading to 0 over ~600ms (`ease-out`).
- **~14 particles**: small primary-colored dots with a soft glow (`box-shadow`), evenly distributed around a circle. Each flies radially outward 34–54px from center, scaling from 1 → 0 and fading out over ~650ms with a springy `cubic-bezier(0.16, 1, 0.3, 1)` curve. Stagger their start with small per-particle delays (0–48ms) so the burst feels organic. Unmount the overlay after the animation finishes.

**Sound (only when marking complete):** Play a short, rewarding "pop + chime".

**Accessibility & polish:** need to pay attention to that.

"for the screens "add" and "settings" I will provide you the description and rough layout drawing later, right now the main goal is ensuring the Ai agent gets the homescreen layout right. Later on I will have it write seed data so that I can test the home screen working properly."
