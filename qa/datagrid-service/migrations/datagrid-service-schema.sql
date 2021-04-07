--Adapted from: https://github.com/Ferlab-Ste-Justine/datagrid-service/blob/main/docker/init_postgresql.sql
CREATE TABLE IF NOT EXISTS data_grid (
    id BIGSERIAL PRIMARY KEY,
    entity_type varchar(75) NOT NULL,
    content json NOT NULL,
    user_id UUID NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);