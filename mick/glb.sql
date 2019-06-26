begin
      global.pr_init('&brn','SYSTEM');
      if glpkss_balance.fn_bal_int(global.current_branch) <> 0 then
           raise_application_error(-20001,'Er in fn_ bal Int');
      end if;

      if glpkss_balance.fn_bal_cust(global.current_branch) <> 0 then
           raise_application_error(-20001,'Er in fn_ bal Int');
      end if;
end;
/

