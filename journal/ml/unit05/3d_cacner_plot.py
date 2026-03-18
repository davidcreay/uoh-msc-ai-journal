import numpy as np
import matplotlib.pyplot as plt
from matplotlib.animation import FuncAnimation
from sklearn.decomposition import PCA
from sklearn.svm import SVC
from sklearn.preprocessing import StandardScaler
from sklearn import datasets

# 1. Setup Data & 3D PCA
data = datasets.load_breast_cancer()
X_scaled = StandardScaler().fit_transform(data.data)
X_pca = PCA(n_components=3).fit_transform(X_scaled)
y = data.target

# 2. Train SVM on 3D data
svm = SVC(kernel='rbf', C=1.0, gamma='auto').fit(X_pca, y)

# 3. Setup the 3D Plot
fig = plt.figure(figsize=(10, 8))
ax = fig.add_subplot(111, projection='3d')

def update(frame):
    ax.clear()
    # Rotate the view point
    ax.view_init(elev=20, azim=frame)
    
    # Plot the clusters
    for target, color, label in zip([0, 1], ['salmon', 'skyblue'], data.target_names):
        ax.scatter(X_pca[y == target, 0], 
                   X_pca[y == target, 1], 
                   X_pca[y == target, 2], 
                   c=color, label=label.capitalize(), alpha=0.6, edgecolors='w')
    
    ax.set_title(f"3D Principal Manifold Rotation (Azimuth: {frame}°)")
    ax.set_xlabel("PC 1")
    ax.set_ylabel("PC 2")
    ax.set_zlabel("PC 3")
    ax.legend(loc='upper left')

# 4. Create Animation (360 degrees)
# Note: Increase 'frames' for a smoother video
ani = FuncAnimation(fig, update, frames=np.arange(0, 360, 2), interval=50)

# 5. Save as GIF (Requires 'pillow' or 'imagemagick' installed)
# pip install pillow
ani.save('3d_pca_rotation.gif', writer='pillow')
print("GIF saved as 3d_pca_rotation.gif")