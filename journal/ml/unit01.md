# ML Unit 1

**Module:** Machine Learning  
**Unit:** 1  
**Date:** (optional)

---

## Describe the fundamental principles of ML

Machine learning is a discipline within **Artificial Intelligence** that uses algorithms and computers to make **predictions** and learn **patterns** from data.

---

## Define the difference between unsupervised and supervised learning techniques

There are three main types of machine learning:

1. **Unsupervised** — Given unlabeled data, the algorithm learns structure and patterns in the data (e.g. clustering, dimensionality reduction).
2. **Supervised** — Given labeled data (input–output pairs), the algorithm learns to predict the output for new inputs (e.g. classification, regression).
3. **Reinforcement** — The agent learns by interacting with an environment and receiving rewards or penalties (trial and error).

---

## Apply the basics of linear algebra and differential calculus to ML

### Linear algebra

**Vectors** — Mathematical objects that describe quantities with direction and magnitude. A vector $\mathbf{x}$ in $\mathbb{R}^n$:

$$
\mathbf{x} = \begin{pmatrix} x_1 \\ x_2 \\ \vdots \\ x_n \end{pmatrix} \quad \text{or} \quad \mathbf{x} = (x_1, x_2, \ldots, x_n)
$$

**Matrices** — Ordered collections of vectors (rows or columns). A matrix $\mathbf{A}$ with $m$ rows and $n$ columns:

$$
\mathbf{A} \in \mathbb{R}^{m \times n}, \quad \mathbf{A} = \begin{pmatrix} a_{11} & \cdots & a_{1n} \\ \vdots & \ddots & \vdots \\ a_{m1} & \cdots & a_{mn} \end{pmatrix}
$$

**Transposition** — Swaps rows and columns: $(\mathbf{A}^\top)_{ij} = a_{ji}$. For a column vector $\mathbf{x}$, $\mathbf{x}^\top$ is a row vector.

**Inner product** (dot product) — Multiplication of two vectors, giving a scalar:

$$
\langle \mathbf{x}, \mathbf{y} \rangle = \mathbf{x}^\top \mathbf{y} = \sum_{i=1}^{n} x_i y_i
$$

**Norm** — The length of a vector (distance from origin to the point):

$$
\|\mathbf{x}\| = \sqrt{\langle \mathbf{x}, \mathbf{x} \rangle} = \sqrt{\sum_{i=1}^{n} x_i^2}
$$

**Euclidean distance** — The length of the difference between two vectors:

$$
d(\mathbf{x}, \mathbf{y}) = \|\mathbf{x} - \mathbf{y}\| = \sqrt{\sum_{i=1}^{n} (x_i - y_i)^2}
$$

**Mean** (centre of mass) — The vector of component-wise averages over a set of vectors:

$$
\boldsymbol{\mu} = \frac{1}{n} \sum_{i=1}^{n} \mathbf{x}_i, \quad \text{so} \quad \mu_j = \frac{1}{n} \sum_{i=1}^{n} x_{ij}
$$

### Eigenvalues and eigenvectors

**Eigenvector** — A non-zero vector $\mathbf{v}$ whose direction is unchanged by a linear transformation $\mathbf{A}$ (it is only scaled).

**Eigenvalue** — The scalar $\lambda$ such that:

$$
\mathbf{A} \mathbf{v} = \lambda \mathbf{v}
$$

Eigenvalues and eigenvectors are central to PCA, spectral clustering, and many other ML methods.

### Differential calculus

**Differential calculus** — The study of rates of change. In ML we use derivatives and gradients (e.g. $\frac{\partial f}{\partial x}$, $\nabla f$) for optimisation and training (e.g. gradient descent).
