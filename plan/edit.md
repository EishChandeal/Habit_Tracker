# Vital Information

To maximize the accuracy, professionalism, and alignment of code outputs from **Gemini 3.1 Pro**, **Claude 4.6 Sonnet**, **Claude Opus 4.6**, and **Gemini 3.5 Flash** in a "vibe coding" workflow, you must shift from treating them as interchangeable chatbots to orchestrating a **tiered cognitive pipeline**. The most effective strategy involves matching the specific cognitive strength of each model to the task complexity and strictly managing context handoffs.

## Strategic Model Routing by Task Complexity

The single most impactful change you can make is to stop using your most expensive or capable model for every task. Research indicates that using the wrong model (e.g., Opus for boilerplate) leads to over-engineered, bloated code, while using weaker models for architecture introduces security flaws.

**Claude Opus 4.6** should be reserved exclusively for **deep design and critical logic**. It excels at reasoning through complex database schemas, security layers, and edge cases (processing ~14.7 logical steps per schema). However, it has a tendency to over-engineer simple tasks. Use it when you need to solve a novel architectural problem or handle complex business logic where "hallucination safety" is paramount. It is less likely to guess and more likely to ask for missing files, making it the safest choice for high-stakes coding.

**Claude 4.6 Sonnet** is your **workhorse for planning and quality assurance**. It currently leads in "expert-level knowledge work" (GDPval-AA benchmark) and produces the most idiomatic, maintainable code for standard engineering tasks. It is the superior choice for generating unit tests, writing technical documentation (ADRs), and breaking down high-level requirements into user stories. At a significantly lower cost than Opus, it offers the best balance of quality and speed for 80% of your daily development work.

**Gemini 3.1 Pro** is the **specialist for massive context ingestion**. With a stable 1M token context window, it is the only reliable choice for loading entire monorepos (100K+ lines) to answer cross-file architectural questions or trace race conditions across multiple layers. Use it when the task requires "knowing everything" about the codebase at once. However, be wary of its "guess-first" behavior; it may generate plausible-looking fixes for code it hasn't fully ingested, so always verify its output against specific file contents.

**Gemini 3.5 Flash** is the **execution engine for repetition**. It is designed for high-volume, low-risk tasks like generating CRUD endpoints, form handlers, UI components, and boilerplate tests. It is 93.5% accurate on these repetitive tasks and significantly cheaper. Never use Flash for security logic, complex algorithms, or system architecture, as it prioritizes speed and simplicity over depth, often stripping away necessary safeguards.



## Prompt Engineering Protocols for Professional Output

To receive professional-grade code, your prompts must enforce structure and constrain the model's creative latitude.

**Enforce Structural Handoffs**
When moving from a planning model (Opus/Sonnet) to an execution model (Flash), do not pass a "wall of text." Models like Flash struggle to parse unstructured natural language plans. Instead, force the planning model to output a structured specification (e.g., JSON or a strict component list) and pass only the relevant slice of that context to the execution model. For example, if Opus designs a full auth system, extract *only* the "Login Component Spec" and pass that to Flash to generate the UI code. This reduces interpretation errors and ensures the generated code matches the architectural intent.

**Define the "Anti-Patterns"**
Explicitly tell the model what *not* to do based on its known weaknesses.
*   **For Opus:** "Do not introduce message queues, Kafka clusters, or microservices unless explicitly requested. Keep the architecture monolithic for this MVP."
*   **For Flash:** "Do not optimize for brevity at the expense of security. Include input validation and error handling even if it makes the code longer."
*   **For Gemini 3.1 Pro:** "Do not guess file contents. If a file is not provided in the context, state that you cannot answer rather than hallucinating a solution."

**Role-Based System Prompting**
Assign specific personas to align with the model's strength.
*   **Opus:** "Act as a Principal Software Architect. Focus on scalability, edge cases, and security implications."
*   **Sonnet:** "Act as a Senior Lead Developer. Focus on code readability, idiomatic patterns, and test coverage."
*   **Flash:** "Act as a Junior Developer pair programmer. Generate clean, standard boilerplate code exactly according to the spec."

## Context Management and Window Optimization

How you feed context to these models determines their success rate, especially given the differences in their context windows.

**Leverage Gemini’s 1M Token Window for Discovery**
Use Gemini 3.1 Pro to perform the initial "sweep" of your codebase. Ask it to identify all files related to a specific feature or bug. Once it lists the relevant files, extract those specific files and feed *only* them to Claude Opus or Sonnet for the actual fix. This bypasses Opus’s context limitations (even with its 1M beta window) and prevents Gemini from hallucinating fixes based on incomplete data.

**Avoid Context Dilution**
Do not dump your entire `node_modules` or unrelated service code into the prompt. Even with large context windows, models suffer from "lost in the middle" phenomena where instructions buried in massive text are ignored. Keep prompts focused:
1.  **System Instruction:** Role and constraints.
2.  **Relevant Context:** Only the files/functions being modified.
3.  **Task:** The specific change required.
4.  **Output Format:** Exact code block requirements.

## The "Double-Check" Validation Workflow

Professional code requires verification. Relying on a single model’s output is the primary cause of bugs in AI-assisted development. Implement a mandatory **Multi-Model Verification** step for critical paths.

**The Divergence Test**
For security-critical code (auth, payments, data handling), run the same prompt through two different "thinking" models (e.g., Opus and GPT-4 or Opus and Sonnet).
*   **Agreement:** If both models produce similar logic and security measures, the code is likely safe.
*   **Divergence:** If Opus adds rate limiting and CSRF protection while Flash/Sonnet does not, **trust the more complex solution** for security layers. This divergence highlights where the faster model is oversimplifying a critical requirement.

**The "Simplification" Pass**
Conversely, if Opus generates a complex solution for a simple task, run that output through Gemini 3.5 Flash or Sonnet with the prompt: *"Review this code for over-engineering. Can this be simplified for an MVP without losing core functionality?"* Teams have reported saving weeks of development time by using Flash to strip away unnecessary abstractions introduced by Opus.

**Automated Tooling**
Use integration tools (like the open-source Continue extension) that allow you to switch models within your IDE without copying/pasting. This reduces context-switching time by ~72% and encourages the habit of checking code with multiple models before committing.

## Cost and Efficiency Optimization

Optimizing for accuracy also means optimizing for cost, which indirectly improves your workflow by allowing more iterations.

**Tiered Spending Strategy**
*   **High Cost (Opus):** Use only for the initial 10-20% of the project involving architecture and complex logic.
*   **Mid Cost (Sonnet):** Use for 50% of the work (features, tests, refactoring).
*   **Low Cost (Flash):** Use for the remaining 30% (boilerplate, UI, repetitive CRUD).

Teams adopting this tiered system have reported **37-62% reductions in AI spending** while simultaneously reducing bug reports by 40%. The savings come from avoiding the use of $15/1M token models for tasks that a $0.75/1M token model can handle perfectly.

**Caching for Agents**
If you are running autonomous agent loops, enable context caching. A 5k token system prompt called 1,000 times costs **$7.50 uncached** but only **$0.75 cached**. This allows you to run more validation passes and "vibe checks" without blowing your budget.



---

**Goal:** I am vibe coding, developing a high quality mobile application, a habit tracking app that will be built using flutter/dart, the core principle around which it will be built: "make it easy, make it visible, make it satisfying, make it attractive" for the user using it. Create the screen I am describing here in text and in image.

**Full-Screen Background:** The entire screen is set against a dynamic, fixed, full-screen fixed-position background layer. This layer features a soft, luminous, flowing WebGL shader effect, described as a 'shifting light nebula' with cool blues and hints of purple (referenced as `{{DATA:ANIMATION:ANIMATION_29}}`).

**Main UI Container (Glassmorphism):** All habit cards feature subtle glassmorphism, with a smooth backdrop-blur and soft frosted-edge texture that allows the colorful background nebula to show through. The cards have a clean, minimalist layout with premium text rendering.

**Particle burst (only when marking complete):** Render a transient overlay centered on the button for ~700ms containing:

- A single **glow ring**: a thin primary-colored circular border that starts small and fully opaque, then expands (~scale 1 → 2) while fading to 0 over ~600ms (`ease-out`).
- **~14 particles**: small primary-colored dots with a soft glow (`box-shadow`), evenly distributed around a circle. Each flies radially outward 34–54px from center, scaling from 1 → 0 and fading out over ~650ms with a springy `cubic-bezier(0.16, 1, 0.3, 1)` curve. Stagger their start with small per-particle delays (0–48ms) so the burst feels organic. Unmount the overlay after the animation finishes.

**Sound (only when marking complete):** Play a short, rewarding "pop + chime".

**Accessibility & polish:** need to pay attention to that.

"for the screens "add" and "settings" I will provide you the description and rough layout drawing later, right now the main goal is ensuring the Ai agent gets the homescreen layout right. Later on I will have it write seed data so that I can test the home screen working properly."
