const express = require('express');
const { Pool } = require('pg');
const fs = require('fs'); // Biblioteca nativa do Node para manipular arquivos

const app = express();
app.use(express.json());

// Configuração do pool de conexões com o PostgreSQL
const pool = new Pool({
    user: process.env.DB_USER,
    host: process.env.DB_HOST,
    database: process.env.DB_NAME,
    password: process.env.DB_PASSWORD,
    port: 5432
});

// Garante a existência da tabela de tarefas no banco
pool.query(`
    CREATE TABLE IF NOT EXISTS tarefas (
        id SERIAL PRIMARY KEY,
        titulo VARCHAR(255) NOT NULL,
        descricao TEXT,
        status VARCHAR(50) DEFAULT 'Pendente'
    );
`).catch(err => console.error('Erro ao criar tabela:', err));

// FUNÇÃO DE INTEGRAÇÃO COM A PASTA DO LINUX
function registrarAtividade(acao, detalhes) {
    const dataHora = new Date().toISOString().replace('T', ' ').substring(0, 19);
    const logLine = `[${dataHora}] ${acao} - ${detalhes}\n`;
    
    const caminhoArquivo = '/app/logs_gestao_projetos/historico_atividades.log';
    
    // Tenta gravar no arquivo; se falhar, exibe no console interno do container
    fs.appendFile(caminhoArquivo, logLine, (err) => {
        if (err) console.log('Aviso: Arquivo de log ainda não provisionado pelo script.', err.message);
    });
}

// ==========================================
// ROTAS DA API
// ==========================================

// Listar todas as tarefas
app.get('/api/tarefas', async (req, res) => {
    try {
        const resultado = await pool.query('SELECT * FROM tarefas ORDER BY id DESC');
        res.json(resultado.rows);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

// Criar nova tarefa
app.post('/api/tarefas', async (req, res) => {
    const { titulo, descricao } = req.body;
    try {
        const resultado = await pool.query(
            'INSERT INTO tarefas (titulo, descricao) VALUES ($1, $2) RETURNING *',
            [titulo, descricao]
        );
        registrarAtividade('NOVA TAREFA', `Título: ${titulo}`); // Grava no arquivo Linux
        res.status(201).json(resultado.rows[0]);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

// Editar uma tarefa inteira
app.put('/api/tarefas/:id', async (req, res) => {
    const { id } = req.params;
    const { titulo, descricao } = req.body;
    try {
        const resultado = await pool.query(
            'UPDATE tarefas SET titulo = $1, descricao = $2 WHERE id = $3 RETURNING *',
            [titulo, descricao, id]
        );
        registrarAtividade('EDIÇÃO', `Tarefa ID ${id} atualizada.`); // Grava no arquivo Linux
        res.json(resultado.rows[0]);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

// Mudar apenas o status da tarefa
app.put('/api/tarefas/:id/status', async (req, res) => {
    const { id } = req.params;
    const { status } = req.body;
    try {
        const resultado = await pool.query(
            'UPDATE tarefas SET status = $1 WHERE id = $2 RETURNING *',
            [status, id]
        );
        registrarAtividade('STATUS ALTERADO', `Tarefa ID ${id} mudou para '${status}'.`); // Grava no arquivo Linux
        res.json(resultado.rows[0]);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

// Excluir tarefa
app.delete('/api/tarefas/:id', async (req, res) => {
    const { id } = req.params;
    try {
        await pool.query('DELETE FROM tarefas WHERE id = $1', [id]);
        registrarAtividade('EXCLUSÃO', `Tarefa ID ${id} removida.`); // Grava no arquivo Linux
        res.json({ message: 'Tarefa removida com sucesso' });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

// Inicialização do Servidor Node.js
const PORTA = 3000;
app.listen(PORTA, () => {
    console.log(`API Node.js rodando na porta ${PORTA} e conectada ao PostgreSQL`);
});
