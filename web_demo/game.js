class Game {
    constructor() {
        this.gridSize = 6;
        this.levelNumElement = document.getElementById('level-num');
        this.moveCountElement = document.getElementById('move-count');
        this.gridElement = document.getElementById('game-grid');
        
        this.level = this.loadProgress();
        this.moves = 0;
        this.blocks = [];
        this.collectors = [];
        this.selectedBlock = null;
        
        this.init();
    }

    init() {
        this.createGrid();
        this.loadLevel(this.level);
        this.setupEventListeners();
    }

    createGrid() {
        this.gridElement.innerHTML = '';
        for (let i = 0; i < this.gridSize * this.gridSize; i++) {
            const cell = document.createElement('div');
            cell.className = 'grid-cell';
            this.gridElement.appendChild(cell);
        }
    }

    loadLevel(lvl) {
        this.saveProgress(lvl);
        this.blocks = [];
        this.collectors = [];
        this.moves = 0;
        this.moveCountElement.innerText = this.moves;
        this.levelNumElement.innerText = lvl;
        
        const levelData = this.getLevelData(lvl);
        
        document.querySelectorAll('.block').forEach(b => b.remove());
        document.querySelectorAll('.collector').forEach(c => c.remove());

        levelData.collectors.forEach(c => this.createCollector(c));
        levelData.blocks.forEach(b => this.createBlock(b));
    }

    saveProgress(lvl) {
        localStorage.setItem('colorBlockJam_level', lvl);
    }

    loadProgress() {
        return parseInt(localStorage.getItem('colorBlockJam_level')) || 1;
    }

    getLevelData(lvl) {
        const levels = {
            1: {
                collectors: [
                    { color: 'red', side: 'top', pos: 2 },
                    { color: 'blue', side: 'bottom', pos: 4 },
                    { color: 'green', side: 'left', pos: 3 }
                ],
                blocks: [
                    { id: 1, color: 'red', x: 2, y: 3 },
                    { id: 2, color: 'blue', x: 4, y: 1 },
                    { id: 3, color: 'green', x: 0, y: 3 }
                ]
            },
            2: {
                collectors: [
                    { color: 'yellow', side: 'right', pos: 1 },
                    { color: 'purple', side: 'left', pos: 4 },
                    { color: 'red', side: 'top', pos: 0 }
                ],
                blocks: [
                    { id: 1, color: 'yellow', x: 1, y: 1 },
                    { id: 2, color: 'purple', x: 5, y: 4 },
                    { id: 3, color: 'red', x: 0, y: 5 },
                    { id: 4, color: 'yellow', x: 3, y: 2 }
                ]
            },
            3: {
                collectors: [
                    { color: 'blue', side: 'bottom', pos: 1 },
                    { color: 'green', side: 'bottom', pos: 3 },
                    { color: 'red', side: 'bottom', pos: 5 },
                    { color: 'purple', side: 'top', pos: 2 }
                ],
                blocks: [
                    { id: 1, color: 'blue', x: 1, y: 0 },
                    { id: 2, color: 'green', x: 3, y: 0 },
                    { id: 3, color: 'red', x: 5, y: 0 },
                    { id: 4, color: 'purple', x: 2, y: 5 }
                ]
            }
        };
        return levels[lvl] || levels[1];
    }

    createCollector(data) {
        const wall = document.getElementById('grid-wall');
        const collector = document.createElement('div');
        collector.className = `collector block-${data.color}`;
        
        const offset = 10;
        const cellSize = this.gridElement.clientWidth / this.gridSize;
        
        if (data.side === 'top') {
            collector.style.top = '-10px';
            collector.style.left = `${offset + data.pos * cellSize + cellSize/2 - 10}px`;
        } else if (data.side === 'bottom') {
            collector.style.bottom = '-10px';
            collector.style.left = `${offset + data.pos * cellSize + cellSize/2 - 10}px`;
        } else if (data.side === 'left') {
            collector.style.left = '-10px';
            collector.style.top = `${offset + data.pos * cellSize + cellSize/2 - 10}px`;
        } else if (data.side === 'right') {
            collector.style.right = '-10px';
            collector.style.top = `${offset + data.pos * cellSize + cellSize/2 - 10}px`;
        }
        
        wall.appendChild(collector);
        this.collectors.push({ ...data, element: collector });
    }

    createBlock(data) {
        const block = document.createElement('div');
        block.className = `block block-${data.color}`;
        block.dataset.id = data.id;
        
        const cellSize = this.gridElement.clientWidth / this.gridSize;
        block.style.width = `${cellSize - 8}px`;
        block.style.height = `${cellSize - 8}px`;
        
        this.updateBlockPosition(block, data.x, data.y);
        this.gridElement.appendChild(block);
        
        this.blocks.push({ ...data, element: block });
    }

    updateBlockPosition(block, x, y) {
        const element = block.element || block; // fallback
        const cellSize = this.gridElement.clientWidth / this.gridSize;
        element.style.left = `${x * cellSize + 4}px`;
        element.style.top = `${y * cellSize + 4}px`;
    }

    setupEventListeners() {
        this.gridElement.addEventListener('pointerdown', (e) => {
            const blockEl = e.target.closest('.block');
            if (blockEl) {
                this.selectedBlock = this.blocks.find(b => b.id == blockEl.dataset.id);
                this.startX = e.clientX;
                this.startY = e.clientY;
            }
        });

        window.addEventListener('pointerup', (e) => {
            if (!this.selectedBlock) return;
            const dx = e.clientX - this.startX;
            const dy = e.clientY - this.startY;
            if (Math.abs(dx) > 20 || Math.abs(dy) > 20) {
                if (Math.abs(dx) > Math.abs(dy)) {
                    this.moveBlock(this.selectedBlock, dx > 0 ? 'right' : 'left');
                } else {
                    this.moveBlock(this.selectedBlock, dy > 0 ? 'bottom' : 'top');
                }
            }
            this.selectedBlock = null;
        });

        document.getElementById('reset-btn').onclick = () => this.loadLevel(this.level);
        document.getElementById('hint-btn').onclick = () => {
            alert("Reklam Hazırlanıyor... İpucu yakında eklenecek!");
        };
    }

    moveBlock(block, direction) {
        let newX = block.x;
        let newY = block.y;
        let moved = false;

        while (true) {
            let nextX = newX;
            let nextY = newY;

            if (direction === 'left') nextX--;
            else if (direction === 'right') nextX++;
            else if (direction === 'top') nextY--;
            else if (direction === 'bottom') nextY++;

            // Check if out of bounds (exit/collector)
            if (nextX < 0 || nextX >= this.gridSize || nextY < 0 || nextY >= this.gridSize) {
                // Check if hits a collector
                if (this.checkCollector(block, direction, nextX, nextY)) {
                    this.collectBlock(block);
                    this.incrementMoves();
                    return;
                }
                break;
            }

            // Check collision with other blocks
            if (this.blocks.some(b => b.id !== block.id && b.x === nextX && b.y === nextY)) {
                break;
            }

            newX = nextX;
            newY = nextY;
            moved = true;
        }

        if (moved) {
            block.x = newX;
            block.y = newY;
            this.updateBlockPosition(block.element, newX, newY);
            this.incrementMoves();
            this.checkWin();
        }
    }

    checkCollector(block, direction, x, y) {
        // Simple match logic: if block is at edge and direction leads to matching collector
        return this.collectors.some(c => {
            const isMatch = c.color === block.color;
            if (!isMatch) return false;

            if (direction === 'top' && c.side === 'top' && block.x === c.pos && block.y === 0) return true;
            if (direction === 'bottom' && c.side === 'bottom' && block.x === c.pos && block.y === this.gridSize - 1) return true;
            if (direction === 'left' && c.side === 'left' && block.y === c.pos && block.x === 0) return true;
            if (direction === 'right' && c.side === 'right' && block.y === c.pos && block.x === this.gridSize - 1) return true;
            
            return false;
        });
    }

    collectBlock(block) {
        block.element.style.transform = 'scale(0)';
        block.element.style.opacity = '0';
        setTimeout(() => {
            block.element.remove();
            this.blocks = this.blocks.filter(b => b.id !== block.id);
            this.checkWin();
        }, 200);
    }

    incrementMoves() {
        this.moves++;
        this.moveCountElement.innerText = this.moves;
    }

    checkWin() {
        if (this.blocks.length === 0) {
            setTimeout(() => this.showWinModal(), 500);
        }
    }

    showWinModal() {
        const modal = document.getElementById('modal-container');
        modal.classList.remove('hidden');
        document.getElementById('next-level-btn').onclick = () => {
            modal.classList.add('hidden');
            this.level++;
            this.loadLevel(this.level);
        };
        document.getElementById('share-btn').onclick = () => {
            const text = `Color Block Jam - Seviye ${this.level} tamamlandı! 🧩✨`;
            if (navigator.share) {
                navigator.share({ title: 'Color Block Jam', text: text, url: window.location.href });
            } else {
                alert("Kopyalandı: " + text);
            }
        };
    }
}

// Start Game
window.onload = () => new Game();
