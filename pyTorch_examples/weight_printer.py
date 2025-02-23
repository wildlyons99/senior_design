import torch
import torch.nn as nn
import numpy as np
import torch.optim as optim
from torchvision import datasets, transforms
from torch.utils.data import DataLoader, Subset


transform = transforms.Compose([
    transforms.ToTensor(),
    transforms.Normalize((0.5,), (0.5,))  # Normalize the input images
])

# Load MNIST dataset
train_dataset = datasets.MNIST(root='./data', train=True, transform=transform, download=True)
test_dataset = datasets.MNIST(root='./data', train=False, transform=transform, download=True)

# Filter dataset to only include 0s and 1s for binary classification
train_indices = [i for i, (img, label) in enumerate(train_dataset) if label in [0, 1]]
test_indices = [i for i, (img, label) in enumerate(test_dataset) if label in [0, 1]]

train_dataset = Subset(train_dataset, train_indices)
test_dataset = Subset(test_dataset, test_indices)

# Create data loaders
train_loader = DataLoader(train_dataset, batch_size=32, shuffle=True)
test_loader = DataLoader(test_dataset, batch_size=32, shuffle=False)





true_labels = []

for images, labels in train_loader:
    true_labels.extend(labels.numpy())  # Add labels to the list

# Convert the list of labels to a NumPy array
true_labels = np.array(true_labels)

# Print the array of true labels
print("True labels for the training set:", true_labels)






class SimpleNN(nn.Module):
    def __init__(self):
        super(SimpleNN, self).__init__()
        self.fc1 = nn.Linear(28 * 28, 64)  # Input layer to hidden layer
        self.fc2 = nn.Linear(64, 1)       # Hidden layer to output layer
        self.sigmoid = nn.Sigmoid()

    def forward(self, x):
        x = x.view(-1, 28 * 28)  # Flatten the input
        x = torch.relu(self.fc1(x))
        x = self.sigmoid(self.fc2(x))
        return x

model = SimpleNN()


criterion = nn.BCELoss()  # Binary Cross-Entropy Loss
optimizer = optim.SGD(model.parameters(), lr=0.01)



num_epochs = 5
for epoch in range(num_epochs):
    for images, labels in train_loader:
        labels = labels.float().unsqueeze(1)  # Convert labels to float for BCELoss
        
        # Forward pass
        outputs = model(images)
        loss = criterion(outputs, labels)

        # Backward pass and optimization
        optimizer.zero_grad()
        loss.backward()
        optimizer.step()

    print(f'Epoch [{epoch+1}/{num_epochs}], Loss: {loss.item():.4f}')



# print weights
for name, param in model.named_parameters():
    if param.requires_grad:
        print(f'{name}: {param.data}')
