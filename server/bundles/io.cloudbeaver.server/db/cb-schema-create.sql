
CREATE TABLE CB_SERVER(
    SERVER_NAME VARCHAR(100) NOT NULL,
    SERVER_VERSION VARCHAR(10) NOT NULL,

    SCHEMA_VERSION VARCHAR(10) NOT NULL,

    PRIMARY KEY(SERVER_NAME)
);

CREATE TABLE CB_USER(
    USER_ID VARCHAR(32) NOT NULL,

    IS_ACTIVE CHAR(1) NOT NULL,
    CREATE_TIME TIMESTAMP NOT NULL,

    PRIMARY KEY(USER_ID)
);

CREATE TABLE CB_ROLE(
    ROLE_ID VARCHAR(32) NOT NULL,
    ROLE_NAME VARCHAR(100) NOT NULL,
    ROLE_DESCRIPTION VARCHAR(255) NOT NULL,

    CREATE_TIME TIMESTAMP NOT NULL,

    PRIMARY KEY(ROLE_ID)
);

CREATE TABLE CB_ROLE_PERMISSIONS(
    ROLE_ID VARCHAR(32) NOT NULL,
    PERMISSION_ID VARCHAR(64) NOT NULL,

    GRANT_TIME TIMESTAMP NOT NULL,
    GRANTED_BY VARCHAR(32) NOT NULL,

    PRIMARY KEY(ROLE_ID,PERMISSION_ID),
    FOREIGN KEY(ROLE_ID) REFERENCES CB_ROLE(ROLE_ID) ON DELETE CASCADE
);

CREATE TABLE CB_USER_ROLE(
    USER_ID VARCHAR(32) NOT NULL,
    ROLE_ID VARCHAR(32) NOT NULL,

    GRANT_TIME TIMESTAMP NOT NULL,
    GRANTED_BY VARCHAR(32) NOT NULL,

    PRIMARY KEY(USER_ID,ROLE_ID),
    FOREIGN KEY(USER_ID) REFERENCES CB_USER(USER_ID) ON DELETE CASCADE,
    FOREIGN KEY(ROLE_ID) REFERENCES CB_ROLE(ROLE_ID) ON DELETE CASCADE
);

CREATE TABLE CB_USER_CREDENTIALS(
    USER_ID VARCHAR(32) NOT NULL,
    PROVIDER_ID VARCHAR(32) NOT NULL,
    CRED_ID VARCHAR(32) NOT NULL,
    CRED_VALUE VARCHAR(1024) NOT NULL,

    PRIMARY KEY(USER_ID,PROVIDER_ID,CRED_ID),
    FOREIGN KEY(USER_ID) REFERENCES CB_USER(USER_ID) ON DELETE CASCADE
);

CREATE INDEX CB_USER_CREDENTIALS_SEARCH_IDX ON CB_USER_CREDENTIALS(PROVIDER_ID,CRED_ID);

CREATE TABLE CB_USER_STATE(
    USER_ID VARCHAR(32) NOT NULL,

    USER_CONFIGURATION TEXT NULL,

    UPDATE_TIME TIMESTAMP NOT NULL,

    PRIMARY KEY(USER_ID),
    FOREIGN KEY(USER_ID) REFERENCES CB_USER(USER_ID) ON DELETE CASCADE
);

CREATE TABLE CB_SESSION(
    SESSION_ID VARCHAR(64) NOT NULL,
    USER_ID VARCHAR(32) NULL,

    CREATE_TIME TIMESTAMP NOT NULL,
    LAST_ACCESS_TIME TIMESTAMP NOT NULL,

    PRIMARY KEY(SESSION_ID),
    FOREIGN KEY(USER_ID) REFERENCES CB_USER(USER_ID) ON DELETE CASCADE
);

CREATE TABLE CB_SESSION_STATE(
    SESSION_ID VARCHAR(64) NOT NULL,

    SESSION_STATE TEXT NOT NULL,
    UPDATE_TIME TIMESTAMP NOT NULL,

    PRIMARY KEY(SESSION_ID),
    FOREIGN KEY(SESSION_ID) REFERENCES CB_SESSION(SESSION_ID) ON DELETE CASCADE
);

CREATE TABLE CB_SESSION_LOG(
    SESSION_ID VARCHAR(64) NOT NULL,

    LOG_TIME TIMESTAMP NOT NULL,
    LOG_ACTION VARCHAR(128) NOT NULL,
    LOG_DETAILS VARCHAR(255) NOT NULL,

    FOREIGN KEY(SESSION_ID) REFERENCES CB_SESSION(SESSION_ID) ON DELETE CASCADE
);

CREATE INDEX CB_SESSION_LOG_INDEX ON CB_SESSION_LOG(SESSION_ID,LOG_TIME);
