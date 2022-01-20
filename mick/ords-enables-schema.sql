BEGIN
  ORDS.enable_schema(
    p_enabled             => TRUE,
    p_schema              => user,
    p_url_mapping_type    => 'BASE_PATH',
    p_url_mapping_pattern => lower(user),
    p_auto_rest_auth      => FALSE
  );
    
  COMMIT;
END;
/
