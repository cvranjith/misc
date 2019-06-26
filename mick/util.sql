
create or replace and compile
java source named "Util"
as
import java.io.*;
import java.lang.*;

public class Util extends Object
{
public static int RunThis(String args)
{
Runtime rt = Runtime.getRuntime();
int        rc = -1;

try
{
Process p = rt.exec(args);

int bufSize = 4096;
BufferedInputStream bis =
new BufferedInputStream(p.getInputStream(), bufSize);
int len;
byte buffer[] = new byte[bufSize];

// Echo back what the program spit out
while ((len = bis.read(buffer, 0, bufSize)) != -1)
System.out.write(buffer, 0, len);

rc = p.waitFor();
}
catch (Exception e)
{
e.printStackTrace();
rc = -1;
}
finally
{
return rc;
}
}
}
/

