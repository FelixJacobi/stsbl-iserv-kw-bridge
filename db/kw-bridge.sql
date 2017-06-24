CREATE USER kw_bridge;

GRANT SELECT ON kw TO kw_bridge;
GRANT SELECT ON kw_participants TO kw_bridge;
GRANT SELECT ON kw_user_choices TO kw_bridge;
GRANT SELECT ON members TO kw_bridge;
