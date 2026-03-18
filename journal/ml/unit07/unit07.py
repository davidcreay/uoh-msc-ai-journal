import os
import numpy as np
import matplotlib.pyplot as plt
import matplotlib.animation as animation
import math

# Ensure images directory exists
os.makedirs("images", exist_ok=True)

# ---------------------------------------------------------
# 1. ANN Fundamentals: Feedforward signal propagation
# ---------------------------------------------------------
fig1, ax1 = plt.subplots(figsize=(6, 4))
ax1.set_xlim(0, 4)
ax1.set_ylim(0, 4)
ax1.axis('off')
ax1.set_title("ANN Fundamentals: Forward Propagation")

# Define layer coordinates
layers = {
    'input': [(1, 1), (1, 2), (1, 3)],
    'hidden': [(2, 0.5), (2, 1.5), (2, 2.5), (2, 3.5)],
    'output': [(3, 1.5), (3, 2.5)]
}

# Draw connections
for p1 in layers['input']:
    for p2 in layers['hidden']:
        ax1.plot([p1[0], p2[0]], [p1[1], p2[1]], color='gray', alpha=0.3, zorder=1)
for p1 in layers['hidden']:
    for p2 in layers['output']:
        ax1.plot([p1[0], p2[0]], [p1[1], p2[1]], color='gray', alpha=0.3, zorder=1)

# Draw nodes
nodes = []
for layer_name, coords in layers.items():
    for x, y in coords:
        node, = ax1.plot(x, y, 'o', markersize=15, color='lightblue', zorder=2)
        nodes.append((layer_name, node))

def animate_ann(frame):
    # Highlight layers sequentially to simulate data flow
    active_layer = 'input' if frame % 3 == 0 else ('hidden' if frame % 3 == 1 else 'output')
    
    for layer_name, node in nodes:
        if layer_name == active_layer:
            node.set_color('orange')
            node.set_markersize(18)
        else:
            node.set_color('lightblue')
            node.set_markersize(15)
    return [n[1] for n in nodes]

print("Generating ANN Fundamentals animation...")
ani1 = animation.FuncAnimation(fig1, animate_ann, frames=12, interval=600, blit=True)
ani1.save("images/ann_fundamentals.gif", writer='pillow')
plt.close(fig1)


# ---------------------------------------------------------
# 2. Willshaw Nets: Binary Association
# ---------------------------------------------------------
fig2, ax2 = plt.subplots(figsize=(6, 4))
ax2.set_xlim(0, 3)
ax2.set_ylim(0, 5)
ax2.axis('off')
ax2.set_title("Willshaw Net: Binary Association Stored")

# Input and Output nodes
input_nodes = [(1, y) for y in range(1, 5)]
output_nodes = [(2, y) for y in range(1, 5)]

# Draw all possible connections faintly
lines = []
for p1 in input_nodes:
    for p2 in output_nodes:
        line, = ax2.plot([p1[0], p2[0]], [p1[1], p2[1]], color='lightgray', lw=1, zorder=1)
        lines.append(line)

# Draw nodes
in_scatter = ax2.scatter([p[0] for p in input_nodes], [p[1] for p in input_nodes], s=200, c='white', edgecolors='black', zorder=2)
out_scatter = ax2.scatter([p[0] for p in output_nodes], [p[1] for p in output_nodes], s=200, c='white', edgecolors='black', zorder=2)

def animate_willshaw(frame):
    # Pattern to associate: Input 2 & 4 -> Output 1 & 3
    active_in = [1, 3] # 0-indexed
    active_out = [0, 2]
    
    in_colors = ['black' if i in active_in and frame > 0 else 'white' for i in range(4)]
    out_colors = ['black' if i in active_out and frame > 1 else 'white' for i in range(4)]
    
    in_scatter.set_facecolors(in_colors)
    out_scatter.set_facecolors(out_colors)
    
    # Solidify binary connections if both input and output are active
    idx = 0
    for i in range(4):
        for j in range(4):
            if i in active_in and j in active_out and frame > 2:
                lines[idx].set_color('black')
                lines[idx].set_linewidth(2)
            else:
                lines[idx].set_color('lightgray')
                lines[idx].set_linewidth(1)
            idx += 1
            
    return [in_scatter, out_scatter] + lines

print("Generating Willshaw Net animation...")
ani2 = animation.FuncAnimation(fig2, animate_willshaw, frames=6, interval=800, blit=True)
ani2.save("images/willshaw.gif", writer='pillow')
plt.close(fig2)


# ---------------------------------------------------------
# 3. Hopfield Networks: Settling into a state
# ---------------------------------------------------------
fig3, ax3 = plt.subplots(figsize=(5, 5))
ax3.set_xlim(-1.5, 1.5)
ax3.set_ylim(-1.5, 1.5)
ax3.axis('off')
ax3.set_title("Hopfield Net: Settling to Energy Minimum")

# Arrange 6 nodes in a circle
num_nodes = 6
angles = np.linspace(0, 2 * np.pi, num_nodes, endpoint=False)
nodes_x = np.cos(angles)
nodes_y = np.sin(angles)

# Fully connect them (except to themselves)
for i in range(num_nodes):
    for j in range(i + 1, num_nodes):
        ax3.plot([nodes_x[i], nodes_x[j]], [nodes_y[i], nodes_y[j]], color='gray', alpha=0.4, zorder=1)

hopfield_nodes = ax3.scatter(nodes_x, nodes_y, s=400, c='white', edgecolors='black', zorder=2)

# Simulated states settling from random noise to a stable pattern
states = [
    [1, 0, 1, 0, 1, 0], # Frame 0: random
    [1, 1, 0, 0, 1, 0], # Frame 1: updating
    [1, 1, 0, 0, 1, 1], # Frame 2: updating
    [1, 1, 0, 0, 1, 1], # Frame 3: Stable
    [1, 1, 0, 0, 1, 1]  # Frame 4: Stable
]

def animate_hopfield(frame):
    # Loop the animation
    current_state = states[frame % len(states)]
    colors = ['#2ca02c' if s == 1 else '#d62728' for s in current_state]
    hopfield_nodes.set_facecolors(colors)
    return hopfield_nodes,

print("Generating Hopfield Net animation...")
ani3 = animation.FuncAnimation(fig3, animate_hopfield, frames=10, interval=500, blit=True)
ani3.save("images/hopfield.gif", writer='pillow')
plt.close(fig3)

print("Success! All remaining animations saved.")